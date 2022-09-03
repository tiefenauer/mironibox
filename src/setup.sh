sudo apt install software-properties-common
sudo apt update
sudo apt upgrade

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
