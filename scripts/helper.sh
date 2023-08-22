#!/bin/bash

# Check if it's running by root (it should not)
if [ "$(id -u)" == 0 ]; then
  echo "[HELPER] DO NOT RUN THIS SCRIPT AS ROOT!"
  echo "[HELPER] canceling..."
  exit 1
fi

# Check internet connection
ping -c 1 8.8.8.8 >/dev/null 2>&1
if [ $? -eq 0 ]; then
  echo "[HELPER] INTERNET OK!"
else
  echo "[HELPER] THIS SCRIPT REQUIRES INTERNET!"
  echo "[HELPER] canceling..."
  exit 1
fi

############################
#     PATH DECLARATION     #
############################

pdc_git="/home/pi/printerdataconfig"
pdc_klipper="/home/pi/printer_data/config"

############################
#   VARIABLE DECLARATION   #
############################

bootcmdline_path=/boot/cmdline.txt

bootcmdline_add="consoleblank=1 logo.nologo quiet loglevel=0 plymouth.enable=0 vt.global_cursor_default=0 plymouth.ignore-serial-consoles splash fastboot noatime nodiratime noram"

sxservice="[Unit]
Description=Syncraft USB Mount Service

[Install]
WantedBy=graphical-session.target

[Service]
ExecStart=/usr/bin/udiskie --automount --no-config --notify --tray --appindicator
"

rclocal='#!/bin/sh -e

sleep 1 && sudo systemctl daemon-reload && service systemd-udevd --full-restart && sudo service sxusb start &

path="/home/pi/printerdataconfig/scripts/transfer.py"
if [ -e "$path" ]; then
    python3 $path
else
    echo "[SYNCRAFT] transfer.py Script not Found."
fi

path="/home/pi/printer_data/config/scripts/startup_script.sh"
if [ -e "$path" ]; then
    bash $path
else
    echo "[SYNCRAFT] Startup Script not found."
fi

exit 0
'

saveconfig_text='
#*# <---------------------- SAVE_CONFIG ---------------------->
#*# DO NOT EDIT THIS BLOCK OR BELOW. The contents are auto-generated.
#*#
#*# [probe]
#*# z_offset = -0.360
#*#
#*# [stepper_z]
#*# position_endstop = 342.855
#*#
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

cd ~

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

######################################
#         APPLY TEXT VARIABLES       #
######################################

process='Modify CMDLINE.'
echo "[HELPER] START: $process."
if grep -q "rootwait" "$bootcmdline_path"; then
    bootcmdline_store_clean=$(grep "rootwait" "$bootcmdline_path" | sed 's/\(rootwait\).*$/\1/')
    echo -e "$bootcmdline_store_clean $bootcmdline_add" | sudo tee /boot/cmdline.txt
    sudo chmod +x /boot/cmdline.txt
    echo "[HELPER] DONE: $process."
else
    echo "[HELPER] ERROR: $process."
fi

process='Modify RC.LOCAL.'
echo "[HELPER] START: $process."
echo -e "$rclocal" | sudo tee /etc/rc.local
sudo chmod +x /etc/rc.local
echo "[HELPER] DONE: $process."

process='Modify Xwrapper Config.'
echo "[HELPER] START: $process."
echo -e "$xwrapper" | sudo tee /etc/X11/Xwrapper.config
sudo chmod +x /etc/X11/Xwrapper.config
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
cd /home/pi/printer_data/gcodes
sudo mv media USB
mkdir .JOB
echo "[HELPER] DONE: $process."

cd ~

process='Create Transfer Python Script.'
echo "[HELPER] START: $process."
cd $pdc_git/scripts
sudo cp $pdc_git/scripts/backup-transfer.py $pdc_git/scripts/transfer.py
echo "[HELPER] DONE: $process."

process='Use First Transfer Python Script.'
echo "[HELPER] START: $process."
sudo python3 $pdc_git/scripts/first-transfer.py
echo "[HELPER] DONE: $process."

process='Add saveconfig to printer.cfg File.'
echo "[HELPER] START: $process."
echo "$saveconfig_text" >> "$pdc_klipper/printer.cfg"
echo "[HELPER] DONE: $process."

process='Add "777" permission on RPy Brightness File.'
echo "[HELPER] START: $process."
sudo chmod 777 /sys/class/backlight/*/brightness
echo "[HELPER] DONE: $process."

cd ~

echo -e "\n\n[HELPER] DONE."