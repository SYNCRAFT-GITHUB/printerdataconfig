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

        ks_config_file_path="/home/pi/printer_data/config/KlipperScreen.conf"
        reference_line="#*# <---------------------- SAVE_CONFIG ---------------------->"
        extracted_saveconfig="$ptrdc_dir_bckp/extract-saveconfig.txt"
        should_save=0
        > "$extracted_saveconfig"

        while IFS= read -r line || [[ -n "$line" ]]; do
            if [[ $should_save -eq 1 ]]; then
                echo "$line" >> "$extracted_saveconfig"
            fi
            if [[ $line == "$reference_line" ]]; then
                should_save=1
                echo "$line" >> "$extracted_saveconfig"
            fi
        done < "$ks_config_file_path"


    else
        echo "[SYNCRAFT] Syncraft X1 is running Legacy System."
    fi
else
    echo "[SYNCRAFT] File does not exist, so this Syncraft X1 is running Legacy System."
fi