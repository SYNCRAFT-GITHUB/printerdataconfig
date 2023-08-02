#!/bin/bash

if [ "$(id -u)" == 0 ]; then
  echo "[HELPER] DO NOT RUN THIS SCRIPT AS ROOT!"
  echo "[HELPER] canceling..."
  exit 1
fi

cd ~
echo "[HELPER] ~"

git clone https://github.com/julianschill/klipper-led_effect.git
echo "[HELPER] git clone klipper-led_effect DONE."

bash klipper-led_effect/install-led_effect.sh
echo "[HELPER] install klipper-led_effect DONE."

cd ~

sudo rm -r KlipperScreen
echo "[HELPER] removed KlipperScreen folder."

git clone -b syncraftx2 https://github.com/SYNCRAFT-GITHUB/KlipperScreen.git
echo "[HELPER] new KlipperScreen folder created from git clone."

sudo rm -r ~/mainsail
echo "[HELPER] removed mainsail folder from ~."

mkdir mainsail
echo "[HELPER] created mainsail folder."

cd ~/mainsail

wget https://github.com/SYNCRAFT-GITHUB/mainsail/releases/latest/download/mainsail.zip
echo "[HELPER] downloaded latest syncraft mainsail release."

unzip mainsail.zip
echo "[HELPER] unzip mainsail.zip."

sudo apt-get install udiskie
echo "[HELPER] installed udiskie."

sudo ln -s /media/ /home/pi/printer_data/gcodes/
echo "[HELPER] created system link in gcodes folder."
cd ~/printer_data/gcodes
echo "[HELPER] cd ~/printer_data/gcodes"
sudo mv media USB
echo "[HELPER] renamed /media/ to /USB/"
mkdir .JOB
echo "[HELPER] created .JOB folder"

cd ~
echo "[HELPER] cd ~"

cd ~/printerdataconfig/scripts
echo "[HELPER] cd ~/printerdataconfig/scripts"

sudo cp ~/printerdataconfig/scripts/backup-transfer.py ~/printerdataconfig/scripts/transfer.py
echo "[HELPER] created transfer.py script"

cd ~
echo "[HELPER] cd ~"