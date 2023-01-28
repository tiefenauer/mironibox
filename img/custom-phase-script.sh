#!/bin/bash
#set -x

#
# Sample sdm Custom Phase script
#
function loadparams() {
    local mpt=""
    [ "$SDMNSPAWN" == "Phase0" ] && mpt=$SDMPT
    source $mpt/etc/sdm/sdm-readparams
}
# $1 is the phase: "0", "1", or "post-install"

#
# Main code for the script
#
phase=$1
pfx="$(basename $0)"     #For messages

loadparams
user_name=$myuser
user_password=$passworduser
current_dir=$(pwd)
echo "Current directory is $current_dir"

local_src=$(dirname "$current_dir")/src/.
local_home="/home/$user_name"
remote_home="$SDMPT$local_home"

local_hotspot_ui=$(dirname "$current_dir")/wifi-connect/ui/build
remote_hotspot_ui="$remote_home/hotspot-ui"

remote_authorized_keys=$remote_home/.ssh/$local_authorized_keys

if [ $phase == "0" ]
then
    #
    # In Phase 0 all references to directories in the image must be preceded by $SDMPT
    #
    logtoboth "* $pfx Phase 0"

# INSERT Your Custom Phase 0 code here
    echo "Checking out latest version of hotspot UI"
    pushd ../wifi-connect/
    git checkout master
    git pull
    popd

    echo "Copying content of $local_src to $remote_home"
    cp -a $local_src $remote_home
    echo "Copying of $local_hotspot_ui to $remote_hotspot_ui"
    cp -a $local_hotspot_ui $remote_hotspot_ui

    echo "Copying SSH key (public) to $remote_authorized_keys"
    install -d -m 700
    cat /home/"$(logname)"/.ssh/mironibox.pub >> $remote_authorized_keys

    logtoboth "* $pfx Phase 0 Completed"

elif [ "$phase" == "1" ]
then
    #
    # Phase 1 (in nspawn)
    #
    logtoboth "* $pfx Phase 1"
    logfreespace "at start of $pfx Phase 1"
    #
    # INSERT your Custom Phase 1 customization stuff here
    # In Phase 1 all references to directories in the image can be direct
    #
    pwd

    logfreespace "at end of $pfx Phase 1"
    logtoboth "* $pfx Phase 1 Completed"
else
    #
    # Post-install edits
    #
    logtoboth "* $pfx Custom Phase post-install"
    logfreespace "at start of $pfx Custom Phase post-install"
    #
    # INSERT Your Custom Phase post-install code here
    # In Phase post-install all references to directories in the image can be direct
    #
    pwd

    logtoboth "Installing wifi-connect (https://github.com/balena-os/wifi-connect)"
    curl -L https://github.com/balena-io/wifi-connect/raw/master/scripts/raspbian-install.sh | bash -s -- -y

    logtoboth "Installing OnOff-Shim (https://shop.pimoroni.com/products/onoff-shim?variant=41102600138)"
    curl https://get.pimoroni.com/onoffshim | sudo -u "$(logname)" bash -s -- -y

    logtoboth "Setting Samba password for user"
    (echo "$user_password"; echo "$user_password") | smbpasswd -s -a "$user_name"

    logtoboth "Installing Python packages"
    pip install -r $remote_home/requirements.txt

    logtoboth "Setting permissions"
    chmod +x "/home/$user_name/run.sh"
    chmod 644 $remote_authorized_keys
    chown $user_name:$user_name $remote_authorized_keys

    logfreespace "at end of $pfx Custom Phase post-install"
    logtoboth "* $pfx Custom Phase post-install Completed"

fi
