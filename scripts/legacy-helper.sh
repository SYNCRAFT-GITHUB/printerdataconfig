#!/bin/bash

cd /home/pi
echo "[HELPER] /home/pi"

git clone https://github.com/julianschill/klipper-led_effect.git
echo "[HELPER] git clone klipper-led_effect DONE."

bash klipper-led_effect/install-led_effect.sh
echo "[HELPER] install klipper-led_effect DONE."

git clone -b legacy/v3 https://github.com/mainsail-crew/crowsnest.git
echo "[HELPER] git clone crowsnest DONE."

sudo rm -r KlipperScreen
echo "[HELPER] removed KlipperScreen folder."

git clone -b syncraftx1 https://github.com/SYNCRAFT-GITHUB/KlipperScreen.git
echo "[HELPER] git clone KlipperScreen DONE."

sudo apt-get install omxplayer
echo "[HELPER] install omxplayer DONE."

sudo apt-get install usbmount -y
echo "[HELPER] install usbmount DONE."

sudo rm -r ~/mainsail
echo "[HELPER] removed mainsail folder."

mkdir mainsail
echo "[HELPER] created empty mainsail folder."

cd ~/mainsail
echo "[HELPER] /home/pi/mainsail"

wget https://github.com/SYNCRAFT-GITHUB/mainsail/releases/latest/download/mainsail.zip
echo "[HELPER] wget mainsail (zip file) DONE."

unzip mainsail.zip
echo "[HELPER] unzip mainsail.zip DONE."

cd /home/pi
echo "[HELPER] /home/pi"

cp /home/pi/printer_data/config/backups/backup-printer.cfg /home/pi/printer_data/config/printer.cfg
cp /home/pi/printer_data/config/backups/backup-variables.cfg /home/pi/printer_data/config/variables.cfg
cp /home/pi/printer_data/config/backups/backup-KlipperScreen.conf /home/pi/printer_data/config/KlipperScreen.conf
chown pi /home/pi/printer_data/config/printer.cfg
chown pi /home/pi/printer_data/config/variables.cfg
chown pi /home/pi/printer_data/config/KlipperScreen.conf
echo "[HELPER] The new printer.cfg file has been created."
echo "[HELPER] The new variables.cfg file has been created."
echo "[HELPER] The new KlipperScreen.conf file has been created."
echo "[HELPER] File owner defined as \"pi\" for all files."
python3 /home/pi/printer_data/config/scripts/python/addsaveconfig.py

cd /home/pi/printer_data/gcodes
echo "[HELPER] /home/pi/printer_data/gcodes"

mkdir USB
echo "[HELPER] created empty USB Folder"

cd /home/pi
echo "[HELPER] /home/pi"

echo "[HELPER] DONE."
