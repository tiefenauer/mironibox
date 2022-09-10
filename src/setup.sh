sudo apt update
sudo apt upgrade

sudo apt install software-properties-common
# GPIO library
sudo apt install python3-gpiozero
# to play sound
sudo apt-get install mplayer
# pygame does not work on raspian
# sudo apt-get install python3-pygame

#############################
# install/configure hardware
#############################
echo "Installing OnOffShim"
curl https://get.pimoroni.com/onoffshim | bash
echo "done!"

echo "Configuring HiFiBerry MiniAmp"
sudo sh -c "echo 'dtoverlay=hifiberry-dac' >> /boot/config.txt"
echo "done!"

echo "Configuring RFID-RC522"
sudo sh -c "echo 'dtparam=spi=on' >> /boot/config.txt"
echo "done!"

#############################
# configure system
#############################
echo "installing samba"
sudo apt install samba
sudo apt-get install samba samba-common smbclient
alias ll='ls -al'

echo "configuring samba"
sudo mv /etc/samba/smb.conf /etc/samba/smb.conf_backup
sudo cp ./config/smb.conf /etc/samba/
mkdir /home/pi/raspishare/
sudo smbpasswd -a username
sudo service smbd restart
sudo service nmbd restart

echo "setting permissions on scripts"
sudo chmod -x setup.sh
sudo chmod -x run.sh
