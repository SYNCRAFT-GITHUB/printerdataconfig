#!/bin/bash

if [ "$(id -u)" == 0 ]; then
  echo "[HELPER] DO NOT RUN THIS SCRIPT AS ROOT!"
  echo "[HELPER] canceling..."
  exit 1
fi

ping -c 1 8.8.8.8 >/dev/null 2>&1

if [ $? -eq 0 ]; then
  echo "[HELPER] INTERNET OK!"
else
  echo "[HELPER] DO NOT RUN THIS SCRIPT WITHOUT INTERNET!"
  echo "[HELPER] canceling..."
  exit 1
fi

############################
#   VARIABLE DECLARATION   #
############################

bootcmdline="console=serial0,115200 console=tty1 root=PARTUUID=9aa55f1b-02 rootfstype=ext4 fsck.repair=yes rootwait consoleblank=1 logo.nologo quiet loglevel=0 plymouth.enable=0 vt.global_cursor_default=0 plymouth.ignore-serial-consoles splash fastboot noatime nodiratime noram"

sxservice="[Unit]
Description=Syncraft USB Mount Service

[Install]
WantedBy=graphical-session.target

[Service]
ExecStart=/usr/bin/udiskie --automount --no-config --notify --tray --appindicator
"

rclocal='#!/bin/sh -e

_IP=$(hostname -I) || true
if [ "$_IP" ]; then
  printf "Syncraft IP: %s\n" "$_IP"
fi

sleep 1 && sudo systemctl daemon-reload && service systemd-udevd --full-restart && sudo service sxusb start &
python3 /home/pi/printerdataconfig/scripts/transfer.py &
/home/pi/printer_data/config/scripts/startup_script.sh &

exit 0
'

xwrapper='allowed_users=anybody
needs_root_rights=yes'

diskrules="ENV{ID_FS_USAGE}==\"filesystem\", ENV{UDISKS_FILESYSTEM_SHARED}=\"1\""

#############################
#       INSTALL STUFF       #
#############################

cd ~

process='Install Klipper LED Effect'
echo "[HELPER] START: $process."
git clone --quiet https://github.com/julianschill/klipper-led_effect.git
bash klipper-led_effect/install-led_effect.sh
echo "[HELPER] install klipper-led_effect DONE."
echo "[HELPER] DONE: $process."

cd ~

process='Apply Syncraft X2 KlipperScreen'
echo "[HELPER] START: $process."
sudo rm -r KlipperScreen
echo "[HELPER] removed KlipperScreen folder."
git clone --quiet -b syncraftx2 https://github.com/SYNCRAFT-GITHUB/KlipperScreen.git
echo "[HELPER] DONE: $process."

process='Apply Syncraft Mainsail'
echo "[HELPER] START: $process."
sudo rm -r ~/mainsail
mkdir mainsail
cd ~/mainsail
wget -q https://github.com/SYNCRAFT-GITHUB/mainsail/releases/latest/download/mainsail.zip
unzip -q mainsail.zip
echo "[HELPER] DONE: $process."

process='Install Udiskie'
echo "[HELPER] START: $process."
sudo apt-get install -qqy udiskie
echo "[HELPER] DONE: $process."

process='Install LightDM'
echo "[HELPER] START: $process."
sudo apt-get install -qqy lightdm
echo "[HELPER] DONE: $process."

process='Install VLC Player'
echo "[HELPER] START: $process."
sudo apt-get install -qqy vlc
echo "[HELPER] DONE: $process."

process='Install MPlayer'
echo "[HELPER] START: $process."
sudo apt-get install -qqy mplayer
echo "[HELPER] DONE: $process."

cd ~

process='Install Swift Lang.'
echo "[HELPER] START: $process."
curl -s https://archive.swiftlang.xyz/install.sh | sudo bash
sudo apt install -qqy swiftlang
echo "[HELPER] DONE: $process."

######################################
#         APPLY TEXT VARIABLES       #
######################################

process='Modify CMDLINE.'
echo "[HELPER] START: $process."
echo -e "$bootcmdline" | sudo tee /boot/cmdline.txt
echo "[HELPER] DONE: $process."

process='Modify RC.LOCAL.'
echo "[HELPER] START: $process."
echo -e "$rclocal" | sudo tee /etc/rc.local
echo "[HELPER] DONE: $process."

process='Modify Xwrapper Config.'
echo "[HELPER] START: $process."
echo -e "$xwrapper" | sudo tee /etc/X11/Xwrapper.config
echo "[HELPER] DONE: $process."

process='Create USB Service.'
echo "[HELPER] START: $process."
echo -e "$sxservice" | sudo tee /etc/systemd/system/sxusb.service
echo "[HELPER] DONE: $process."

process='Apply udisks Rules.'
echo "[HELPER] START: $process."
echo $diskrules | sudo tee /etc/udev/rules.d/99-udisks2.rules
echo "[HELPER] DONE: $process."

###########################################
#         ADJUST PRINTER_DATA STUFF       #
###########################################

process='Create System Link in Gcodes Folder.'
echo "[HELPER] START: $process."
sudo ln -s /media/ /home/pi/printer_data/gcodes/
cd ~/printer_data/gcodes
sudo mv media USB
mkdir .JOB
echo "[HELPER] DONE: $process."

cd ~

process='Create Transfer Python Script.'
echo "[HELPER] START: $process."
cd ~/printerdataconfig/scripts
sudo cp ~/printerdataconfig/scripts/backup-transfer.py ~/printerdataconfig/scripts/transfer.py
echo "[HELPER] DONE: $process."

cd ~

echo -e "\n\n[HELPER] DONE."