#!/bin/bash
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
user_name=mironibox
user_password=mironibox

echo "Running Raspibox custom phase script with arguments:"
echo $@
echo "Custom params: user_name=$user_name, user_password=$user_password"

if [ $phase == "0" ]
then
    #
    # In Phase 0 all references to directories in the image must be preceded by $SDMPT
    #
    loadparams
    logtoboth "* $pfx Phase 0"

# INSERT Your Custom Phase 0 code here
    current_dir=$(pwd)
    echo "Current directory is $current_dir"
    src_dir=$(dirname "$current_dir")/src/.
    target_dir="$SDMPT/home/$user_name"
    echo "Copying content of $src_dir to $target_dir"
    cp -a "$src_dir" "$target_dir"

    logtoboth "* $pfx Phase 0 Completed"

elif [ "$phase" == "1" ]
then
    #
    # Phase 1 (in nspawn)
    #
    loadparams
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
    loadparams
    logtoboth "* $pfx Custom Phase post-install"
    logfreespace "at start of $pfx Custom Phase post-install"
    #
    # INSERT Your Custom Phase post-install code here
    # In Phase post-install all references to directories in the image can be direct
    #
    pwd

    logtoboth "Installing wifi-connect (https://github.com/balena-os/wifi-connect)"
    curl -L https://github.com/balena-io/wifi-connect/raw/master/scripts/raspbian-install.sh | bash -s -- -y

    echo "Setting Samba password for user"
    (echo "$user_password"; echo "$user_password") | smbpasswd -s -a "$user_name"

    logfreespace "at end of $pfx Custom Phase post-install"
    logtoboth "* $pfx Custom Phase post-install Completed"
fi
