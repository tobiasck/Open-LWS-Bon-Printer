#!/bin/bash

echo "Rechte für Scripte vergeben"
sudo chmod 775 ./OpenLWS.sh
sudo chmod 775 ./OpenLWS.py

echo "Crontab prüfen"
crontab -l > crontab.dump

echo $(cat crontab.dump | grep "@reboot python3")

if [[ $(cat crontab.dump | grep "@reboot python3") == "" ]]
then
	echo "Crontab bearbeiten"
	echo "@reboot python3 $(pwd)/OpenLWS.py" >> crontab.dump
	crontab crontab.dump
fi

rm crontab.dump

echo "Crontab aktivieren"
sudo systemctl enable cron.service

echo "Programm starten"
nohup python3 $(pwd)/OpenLWS.py &

echo "Installation abgeschlossen. Programm gestartet"
