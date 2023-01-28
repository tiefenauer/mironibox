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
connection_changed=1

sec_start=`date +%s`

while true
do
  if ping -c 1 google.com >&/dev/null;
  then
    echo "Mironibox is connected to the internet"
    # wait a few seconds for audio to be initialized (might interfere with startup sound)
    sleep 5
    if [ $connection_changed -eq 0 ]
    then
      mplayer $user_home/audio/wifi-success.wav &
    else
      mplayer $user_home/audio/i18n/en/wifi-connected.wav &
    fi
    exit 0
  else
    sec_now=`date +%s`
    sec_elapsed=`expr ${sec_now} - ${sec_start}`

    if [ $sec_elapsed -lt 30 ]
    then
      # Wait for a few seconds before opening an AP because Mironibox might need some time to connect to a previously established connection
      # If WiFi-Connect is started before Mironibox had a chance to connect, it will be trapped forever in AP mode since the default for ACTIVITY_TIMEOUT is infinity (good)
      continue
    fi

    if [ $first_run -ne 0 ]
    then
      mplayer $user_home/audio/wifi-failure.wav &
    fi
    echo "Looks like Mironibox is not connected to the internet. Opening a WiFi hotspot"
    mplayer $user_home/audio/i18n/en/please_connect_to_hotspot.mp3 &
    sudo wifi-connect --portal-ssid Mironibox --ui-directory $user_home/hotspot-ui
    first_run=1
    connection_changed=0
  fi
  sleep 1
done
