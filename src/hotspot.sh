#!/bin/bash
#
# Automatically open a hotspot and start Wifi-Connect when not connected to a WiFi network
# This will allow you to configure the wireless connection details (SSID and password) from your phone by connecting to the hotspot
# Wifi-connect will do the following:
# - open an access point called 'Mironibox'
# - run a local webserver with a single page to select the Wifi and enter the password
# After connecting to the AP, the user will then be taken to the webpage where he can enter the WiFi details.
# For more information see https://github.com/balena-os/wifi-connect
#

echo "Checking WiFi status:"
nmcli radio wifi

while true
do
	if ping -c 1 google.com >&/dev/null;
  then
    echo "Mironibox is connected to the internet"
    exit 0
  else
    echo "Looks like Mironibox is not connected to the internet. Opening a WiFi hotspot"
    sudo wifi-connect --portal-ssid Mironibox
  fi
	sleep 5
done
