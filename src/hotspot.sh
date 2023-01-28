#!/bin/bash

usage="$(basename "$0") [-h|--help] [-u|--user <string>]
Automatically open a hotspot and start Wifi-Connect when not connected to a WiFi network
This will allow you to configure the wireless connection details (SSID and password) from your phone by connecting to the hotspot
Wifi-connect will do the following:
- open an access point called 'Mironibox'
- run a local webserver with a single page to select the Wifi and enter the password
After connecting to the AP, the user will then be taken to the webpage where he can enter the WiFi details.
For more information see https://github.com/balena-os/wifi-connect

Parameters:
    -h|--help              show this help text
    -u|--user <string>     user name (defaults to 'mironibox' if not set)
"

# Defaults
user_name=mironibox

POSITIONAL=()
while [[ $# -gt 0 ]]
do
key="$1"
case $key in
    -h|--help) echo "${usage}"; shift ; exit ;;
    -u|--user) user_name="$2" shift 2 ;;
esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

user_home=/home/$user_name

echo "Checking WiFi status:"
nmcli radio wifi

first_run=0

while true
do
	if ping -c 1 google.com >&/dev/null;
  then
    echo "Mironibox is connected to the internet"
    mplayer $user_home/audio/wifi-success.wav
    exit 0
  else
    if [ $first_run -ne 0 ]
    then
      mplayer $user_home/audio/wifi-failure.wav
    fi
    echo "Looks like Mironibox is not connected to the internet. Opening a WiFi hotspot"
    mplayer $user_home/audio/i18n/en/please_connect_to_hotspot.mp3
    sudo wifi-connect --portal-ssid Mironibox --ui-directory $user_home/hotspot-ui
    first_run=1
  fi
	sleep 5
done
