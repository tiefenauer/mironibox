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

src_dir=$(dirname "$current_dir")/src/.
user_home="/home/$user_name"

if [ $phase == "0" ]
then
    #
    # In Phase 0 all references to directories in the image must be preceded by $SDMPT
    #
    logtoboth "* $pfx Phase 0"

# INSERT Your Custom Phase 0 code here
    user_home_remote="$SDMPT$user_home"

    #-----------------------------------------------
    # Hotspot UI
    #-----------------------------------------------
    hotspot_ui_dir_local=$(dirname "$current_dir")/wifi-connect/ui/build
    hotspot_ui_dir_remote="$user_home_remote/hotspot-ui"
    echo "Checking out latest version of hotspot UI"
    pushd ../wifi-connect/
    git checkout master
    git pull
    popd
    echo "Copying of $hotspot_ui_dir_local to $hotspot_ui_dir_remote"
    cp -a $hotspot_ui_dir_local $hotspot_ui_dir_remote

    #-----------------------------------------------
    # Mironibox files
    #-----------------------------------------------
    echo "Copying content of $src_dir to $user_home_remote"
    cp -a $src_dir $user_home_remote

    #-----------------------------------------------
    # SSH files
    #-----------------------------------------------
    remote_authorized_keys=$user_home_remote/.ssh/$local_authorized_keys
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
    pip install -r $user_home/requirements.txt

    logtoboth "Setting permissions"
    chmod +x "/home/$user_name/run.sh"
    chmod 644 $local_authorized_keys
    chown $user_name:$user_name $local_authorized_keys

    logfreespace "at end of $pfx Custom Phase post-install"
    logtoboth "* $pfx Custom Phase post-install Completed"

fi
