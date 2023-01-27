# echo "Updating apt"
# sudo apt update -y
# sudo apt upgrade -y

#echo "Installing common software library: software-properties-common"
#sudo apt install software-properties-common -y
#echo "Installing GPIO library: python3-gpiozero"
#sudo apt install python3-gpiozero -y
#echo "Installing library to play sound: mplayer"
#sudo apt-get install mplayer -y
# sudo apt-get install $(cat pkglist)

# pygame does not work on raspian
# sudo apt-get install python3-pygame

#############################
# install/configure hardware
#############################
echo "Installing OnOffShim"
curl https://get.pimoroni.com/onoffshim | bash
echo "done!"

#echo "Configuring HiFiBerry MiniAmp (https://www.hifiberry.com/docs/data-sheets/datasheet-miniamp/)"
#sudo sh -c "echo 'dtoverlay=hifiberry-dac' >> /boot/config.txt"
#echo "done!"

#echo "Configuring RFID-RC522 (https://joy-it.net/files/files/Produkte/SBC-RFID-RC522/SBC-RFID-RC522_Manual_2022-11-22.pdf)"
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
sudo smbpasswd -a pi
sudo service smbd restart
sudo service nmbd restart

echo "setting permissions on scripts"
sudo chmod -x setup.sh
sudo chmod -x run.sh

pip install -r requirements.txt
