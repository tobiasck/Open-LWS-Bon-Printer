#!/bin/bash

sudo chmod o+rw /dev/usb/lp0 # Set Printer Serial Connectin Privilegs

rm /home/$(whoami)/quote

cd /home/$(whoami)/
wget https://api.zitat-service.de/v1/quote

quote=$(cat /home/$(whoami)/quote | grep -oP '"quote":"\K[^"]+')
author=$(cat /home/$(whoami)/quote | grep -oP '"authorName":"\K[^"]+')
quoteLength=${#quote}

for ((i=24; i < ${#quote}; i=i+24)); do
	if [[ ${quote:i:1} != " " ]]
	then
		for ((j=i-1; j > 0; j--)); do
			if [[ ${quote:j:1} == " " ]]; then
				echo "Line Break at Line $j"
				quote=$(echo ${quote:0:j}"#"${quote:j+1})
				i=$(( $j ))
				break
			fi
		done
	else
		quote=$(echo ${quote:0:i}"#"${quote:i+1})
	fi
done

echo "$quote"

quote=$(echo "$quote" | sed 's/ä/\x84/g')
quote=$(echo "$quote" | sed 's/ü/\x81/g')
quote=$(echo "$quote" | sed 's/ö/\x94/g')
quote=$(echo "$quote" | sed 's/Ä/\x8E/g')
quote=$(echo "$quote" | sed 's/Ü/\x9A/g')
quote=$(echo "$quote" | sed 's/Ö/\x99/g')
quote=$(echo "$quote" | sed 's/ß/\xE1/g')
quote=$(echo "$quote" | sed 's/#/\x0A/g')

echo "$quote"

echo -e "\x1b\x74\x00\x1b\x61\x01\x1d\x21\x11" > /dev/usb/lp0
echo -e "\x3d\x3d\x3d\x3d\x3d\x21\x3d\x3d\x3d\x3d\x3d\x0A" > /dev/usb/lp0
echo -e "\x0A" > /dev/usb/lp0
echo -e "$quote" > /dev/usb/lp0
echo -e "\x0A" > /dev/usb/lp0
echo "$author" >  /dev/usb/lp0
echo -e "\x0A" > /dev/usb/lp0
echo -e "\x3d\x3d\x3d\x3d\x3d\x21\x3d\x3d\x3d\x3d\x3d\x0A" > /dev/usb/lp0
echo -e "\x0a\x0a\x0a\x0a\x1d\x56\x42\x00" > /dev/usb/lp0
