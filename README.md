<div align="center">
    <img height="200" src="https://github.com/tiefenauer/mironibox/raw/main/assets/logo/png/logo-no-background.png" />
</div>

# Mironibox

Mironibox is an open source alternative to [Toniebox](https://tonies.com/). This repository contains the code that is needed to be run on a [Raspberry Pi](https://www.raspberrypi.com/). The hardware needs to be assembled by you (I will add a blog post later).  

## Installation

To create an image that can be run on a Raspberry Pi run the following script in a Linux terminal:

```bash
chmod +x ./flash.sh && ./flash.sh
```

The script will do the following:
- Install tools needed to run the script
- Download a RaspbianOS image
- customize and pre-configure the downloaded RaspbianOS image containing all packages and tools needed for Mironibox

## Prerequisites

The scripts used in this `README.md` were tested on Ubuntu 22.04 LTS. The following tools are needed wnd will be installed if not yet present:

- [SDM](https://github.com/gitbls/sdm): needed to create a customized RaspbianOS image
- [Git](https://git-scm.com/): needed to checkout [a fork](https://github.com/tiefenauer/wifi-connect) of [WiFi Connect](https://github.com/balena-os/wifi-connect) containing customized UI files for the WiFi setup
- [xz-utils](https://packages.ubuntu.com/bionic/xz-utils): needed to decompress the downloaded RaspbianOS image

## Setup SD card
Use [Raspberry Imager](https://www.raspberrypi.com/software/) to flash an SD card with RaspianOS using the following settings: 
1. hostname:  `mironibox`
1. Enable SSH 
   2. Allow public-key authentication only: provide key file from your computer
1. Set username and password (must be done to skip first run wizard)
   2. username: pi
   3. password: something you can remember
1. Configure wireless LAN
   2. Enter SSID and password for your WiFi
1. Set locale settings
   2. Time zone: Where you live
   3. keyboard layout: whatever you use

3. boot Raspberry pi (can take a bit on first boot)
4. Optional: find Raspberry IP
   5. on host computer: https://askubuntu.com/questions/82480/how-to-see-all-computers-connected-to-a-network
   6. install arp-scan: `sudo apt-get update -y && sudo apt-get install -y arp-scan`
2. Create key file and copy to raspi: https://serverfault.com/questions/241588/how-to-automate-ssh-login-with-password
3. ssh login: `ssh pi@mironibox`
4. Run gpiotest: https://elinux.org/R-Pi_Troubleshooting#Testing
5. create Samba share: YOU MUST SET A PASSWORD OTHERWISE YOU WILL NOT BE ABLE TO CONNECT!!!!
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
- Debo Tast 1x1: https://secure.reichelt.com/ch/de/entwicklerboards-folientastatur-1x-1-ziffer-debo-tast-1x1-p266086.html?&nbc=1
- PiGlow: https://www.play-zone.ch/de/piglow-led-addon-fur-raspberry-pi.html

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
- buttons: https://www.makeuseof.com/tag/add-button-raspberry-pi-project/
- restore CTRL-ALT-DOWN in IntelliJ: https://stackoverflow.com/questions/47808160/intellij-idea-ctrlaltleft-shortcut-doesnt-work-in-ubuntu
- play sound: https://brightersidetech.com/play-music-and-audio-file-in-python/
- GPIO library: https://gpiozero.readthedocs.io/en/stable/index.html
- GPIOZero double press: https://raspberrypi.stackexchange.com/questions/117390/gpiozero-how-to-double-button-press
