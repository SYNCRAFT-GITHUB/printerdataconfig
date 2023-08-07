#!/bin/bash

echo "[!] Startup Syncraft Script."

legacy_system_path="/home/pi/printerdataconfig/legacy.txt"

if [ -f "$legacy_system_path" ]; then

    is_legacy=$(cat "$legacy_system_path")

    if [ "$is_legacy" = "false" ]; then
        
        ptrdc_dir="/home/pi/printerdataconfig"
        ptrdc_dir_bckp="$ptrdc_dir/backups"

        cp $ptrdc_dir_bckp/backup-printer.cfg $ptrdc_dir/printer.cfg
        cp $ptrdc_dir_bckp/backup-variables.cfg $ptrdc_dir/variables.cfg
        cp $ptrdc_dir_bckp/backup-KlipperScreen.conf $ptrdc_dir/KlipperScreen.conf
        chown pi $ptrdc_dir/printer.cfg
        chown pi $ptrdc_dir/variables.cfg
        chown pi $ptrdc_dir/KlipperScreen.conf

    else
        echo "[SYNCRAFT] Syncraft X1 is running Legacy System."
    fi
else
    echo "[SYNCRAFT] File does not exist, so this Syncraft X1 is running Legacy System."
fi