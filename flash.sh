#!/bin/bash
usage="$(basename "$0") [-h|--help] [-b|--burn] [-d|--desktop] [-m|--mount <string>]
Create a customized image based on RaspbianOS Bullseye which is pre-configured to run Mironibox. The generated image
is being burned onto an SD card located ad /dev/mmcblk0 by default (internal SD card reader). If your device is mounted
at another point, you need to specify it (see parameters below).
By default, RaspbianOS lite is used, which does not include a visual desktop. If you need one, you can set the flag accordingly (see parameters below)

Parameters:
    -h|--help               show this help text
    -c|--customize          create customized image only, do not burn customized image to SD card (default: false)
    -d|--desktop            use Desktop version of RaspbianOS instead of Lite (default: false)
    -m|--mount <string>     mount point of the SD card to burn to (default: /dev/mmcblk0)
    -u|--user <string>      user name (default: mironibox)
    -p|--password <string>  user password (default: mironibox)
"

# Defaults
burn_image=0
desktop_image=1
sd_mount=/dev/mmcblk0
user_name=mironibox
user_password=mironibox

POSITIONAL=()
while [[ $# -gt 0 ]]
do
key="$1"
case $key in
    -h|--help) echo "${usage}"; shift ; exit ;;
    -c|--customize) burn=1 shift ;;
    -d|--desktop) desktop_image=0 shift ;;
    -u|--user) user_name="$2" shift 2 ;;
    -u|--user) user_password="$2" shift 2 ;;
    -m|--mount) sd_mount="$2" shift 2 ;;
esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

#set -x
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
image_basename=2022-09-22-raspios-bullseye-armhf-lite
image_url=https://downloads.raspberrypi.org/raspios_lite_armhf/images/raspios_lite_armhf-2022-09-26/
if [[ $desktop_image -eq 0 ]]
then
  image_basename=2022-09-22-raspios-bullseye-armhf.img
  image_url=https://downloads.raspberrypi.org/raspios_armhf/images/raspios_armhf-2022-09-26/
fi
image_filename="$image_basename".img
image_xz_filename="$image_filename".xz
image_download_url=https://downloads.raspberrypi.org/raspios_lite_armhf/images/raspios_lite_armhf-2022-09-26/$image_xz_filename
image_mironibox_filename="$image_basename"-mironibox.img

ssh_key_file=~/.ssh/"$user_name"

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
if [ ! -f "$ssh_key_file" ]
then
  echo "Generating SSH key for Mironibox user and storing it under $ssh_key_file"
  ssh-keygen -t rsa -b 4096 -C "SSH key for Mironibox" -f $ssh_key_file -N ""
fi

if [ ! -f ./"$image_filename" ]
then
  echo "Downloading RaspbianOS Bullseye (32bit) image"
  wget -q --show-progress $image_download_url
  echo "Extracting..."
  unxz $image_xz_filename
fi

echo "Creating copy of RaspbianOS image for SDM"
cp $image_filename $image_mironibox_filename

echo "Customizing RaspbianOS image using SDM"

sudo sdm --customize \
    --extend --xmb 1024 \
    --apt-dist-upgrade \
    --l10n \
    --cscript custom-phase-script.sh \
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
    --rclocal "bash /home/$user_name/hotspot.sh -u $user_name &" \
    --rclocal "mplayer /home/$user_name/audio/startup.wav &" \
    --rclocal "bash /home/$user_name/run.sh &" \
    --motd motd.txt \
    --batch \
    $image_mironibox_filename

sudo umount /dev/mmcblk0p1
sudo umount /dev/mmcblk0p2

echo "Burning customized image to SD card"
sudo sdm --burn $sd_mount $image_mironibox_filename \
        --expand-root \
        --regen-ssh-host-keys \
        --host mironibox

echo "Cleaning up"
# rm 2022-09-22-raspios-bullseye-armhf-mironibox.img
