# Setup

1. Change hostname to raspibox
2. Create key file and copy to raspi: https://serverfault.com/questions/241588/how-to-automate-ssh-login-with-password
3. ssh login: `ssh pi@raspibox`
4. create Samba share:
   5. https://www.elektronik-kompendium.de/sites/raspberry-pi/2007071.htm
   5. https://ubuntu.com/tutorials/install-and-configure-samba#1-overview
5. check GPIO: http://wiringpi.com/download-and-install/

# Development
1. https://www.jetbrains.com/help/pycharm/configuring-synchronization-with-a-remote-host.html#default_server
2. https://www.gowrishankarnath.com/remote-programming-of-raspberry-pi-using-pycharm.html

# Hardware
- RFID reader: https://joy-it.net/de/products/SBC-RFID-RC522
  - Manual: https://joy-it.net/files/files/Produkte/SBC-RFID-RC522/SBC-RFID-RC522-Anleitung-09-06-2020.pdf
- Pimoroni OnOff Shim: https://shop.pimoroni.com/products/onoff-shim?variant=41102600138
- HiFiBerry Miniamp: 
  - https://www.hifiberry.com/shop/boards/miniamp/
  - https://www.hifiberry.com/docs/data-sheets/datasheet-miniamp/
  - https://www.hifiberry.com/docs/software/configuring-linux-3-18-x/

# Setting up developer environment:

1. make `python` execute `python3` (which should be version 3.9.2): https://askubuntu.com/questions/320996/how-to-make-python-program-command-execute-python-3
2. (optional, only if above does not work): Install Python 3.9.2 (same as raspi): https://www.digitalocean.com/community/questions/how-to-install-a-specific-python-version-on-ubuntu
   2. most commands have to be prefixed with sudo
   3. when creating the symlink, use `python as the target name`
4. install python pip
5. install build essentials: sudo apt install build-essential
6. install simpleaudio: https://simpleaudio.readthedocs.io/en/latest/installation.html


# Helpful links
- requirements.txt vs setup.py: https://stackoverflow.com/questions/43658870/requirements-txt-vs-setup-py
- append to /boot/config.txt: https://raspberrypi.stackexchange.com/questions/52083/bash-command-to-append-to-boot-config-txt
- install python 3.9.2: https://linuxize.com/post/how-to-install-python-3-9-on-ubuntu-20-04/
- switch between python versions: https://unix.stackexchange.com/questions/410579/change-the-python3-default-version-in-ubuntu