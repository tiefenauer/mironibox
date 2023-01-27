#!/bin/sh
cd ./img || exit

cat ./motd.txt
cat << WELCOME

Welcome to the Mironibox-Installer!
This script will flash a customized Raspbian OS pre-configured for Mironibox onto an SD card

WELCOME
sdm_version=$(sudo sdm --version)
git_version=$(sudo git version)
xz_version=$(sudo unxz --version | head -n 1)

# ----------------------------------------------
# Configuration variables
# ----------------------------------------------
user_name=mironibox
user_password=mironibox

# ----------------------------------------------
# Tool installation
# ----------------------------------------------
if [ -z "$sdm_version" ]
then
  echo "Installing SDM (https://github.com/gitbls/sdm)"
  curl -L https://raw.githubusercontent.com/gitbls/sdm/master/EZsdmInstaller | bash
else
  echo "SDM is installed: $sdm_version"
fi

if [ -z "$git_version" ]
then
  echo "Installing Git (https://git-scm.com/)"
  sudo apt-get update
  sudo apt-get install git-all
else
  echo "Git is installed: $git_version"

fi

if [ -z "$xz_version" ]
then
  echo "Installing XZ Utils"
  sudo apt-get update
  sudo apt-get install xz-utils
else
  echo "XZ Utils is installed: $xz_version"
fi

# ----------------------------------------------
# Start of Script
# ----------------------------------------------
if [ ! -f ~/.ssh/mironibox ]
then
  echo "Generating SSH key for Mironibox"
  ssh-keygen -t rsa -b 4096 -C "SSH key for Mironibox" -f ~/.ssh/mironibox -N ""
fi

#if [ ! -f ./2022-09-22-raspios-bullseye-armhf.img ]
if [ ! -f ./2022-09-22-raspios-bullseye-armhf-lite.img ]
then
  echo "Downloading RaspbianOS Bullseye (32bit) image"
#  wget -q --show-progress https://downloads.raspberrypi.org/raspios_armhf/images/raspios_armhf-2022-09-26/2022-09-22-raspios-bullseye-armhf.img.xz
  wget -q --show-progress https://downloads.raspberrypi.org/raspios_lite_armhf/images/raspios_lite_armhf-2022-09-26/2022-09-22-raspios-bullseye-armhf-lite.img.xz
  echo "Extracting..."
#  unxz 2022-09-22-raspios-bullseye-armhf.img.xz
  unxz 2022-09-22-raspios-bullseye-armhf-lite.img.xz
fi

echo "Creating copy of RaspbianOS image for SDM"
cp 2022-09-22-raspios-bullseye-armhf-lite.img 2022-09-22-raspios-bullseye-armhf-mironibox.img

echo "Customizing RaspbianOS image using SDM"

sudo sdm --customize \
    --extend --xmb 1024 \
    --apt-dist-upgrade \
    --l10n \
    --cscript custom-phase-script.sh \
    --custom1 $user_name \
    --custom2 $user_password \
    --disable bluetooth,piwiz,triggerhappy \
    --bootset boot_splash:1,boot_wait:1,camera:1,spi=0 \
    --bootconfig boot_delay:0,boot_delay_ms=0 \
    --nowait-timesync \
    --user $user_name \
    --password-user $user_password \
    --rootpwd \
    --password-same y \
    --autologin \
    --nowpa \
    --poptions apps \
    --apps @mironibox-apps \
    --dtoverlay hifiberry-dac \
    --ssh service \
    --showapt \
    --plugin samba:smbconf=smb.conf \
    --rclocal "exec 1>/home/$user_name/rc.local.log 2>&1" \
    --rclocal "set -x" \
    --rclocal "bash /home/$user_name/hotspot.sh &" \
    --rclocal "mplayer /home/$user_name/startup.wav &" \
    --rclocal "bash /home/$user_name/run.sh &" \
    --motd motd.txt \
    --batch \
    2022-09-22-raspios-bullseye-armhf-mironibox.img

sudo umount /dev/mmcblk0p1
sudo umount /dev/mmcblk0p2

echo "Burning customized image to SD card"
sudo sdm --burn /dev/mmcblk0 2022-09-22-raspios-bullseye-armhf-mironibox.img \
        --expand-root \
        --regen-ssh-host-keys \
        --host mironibox

echo "Cleaning up"
# rm 2022-09-22-raspios-bullseye-armhf-mironibox.img
