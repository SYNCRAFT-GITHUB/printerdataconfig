#!/bin/bash

echo "
[Syncraft Backup Files]

The files will be copied from
> /home/pi/printer_data/config/backups/backup-printer.cfg
> /home/pi/printer_data/config/backups/backup-variables.cfg
> /home/pi/printer_data/config/backups/backup-KlipperScreen.conf
to
> /home/pi/printer_data/config/printer.cfg
> /home/pi/printer_data/config/variables.cfg
> /home/pi/printer_data/config/KlipperScreen.conf

[!] IF A \"printer.cfg\" FILE ALREADY EXISTS, IT WILL BE OVERWRITTEN!
[!] IF A \"variables.cfg\" FILE ALREADY EXISTS, IT WILL BE OVERWRITTEN!
[!] IF A \"KlipperScreen.conf\" FILE ALREADY EXISTS, IT WILL BE OVERWRITTEN!

[*] Type \"GO\" to perform this action, and \"QUIT\" to exit the script.
"

read input

if [[ $input == "GO" || $input == "go" ]]; then
    echo -e "\n\n"
    cp /home/pi/printer_data/config/backups/backup-printer.cfg /home/pi/printer_data/config/printer.cfg
    cp /home/pi/printer_data/config/backups/backup-variables.cfg /home/pi/printer_data/config/variables.cfg
    cp /home/pi/printer_data/config/backups/backup-KlipperScreen.conf /home/pi/printer_data/config/KlipperScreen.conf
    chown pi /home/pi/printer_data/config/printer.cfg
    chown pi /home/pi/printer_data/config/variables.cfg
    chown pi /home/pi/printer_data/config/KlipperScreen.conf
    echo "[*] The new printer.cfg file has been created."
    echo "[*] The new variables.cfg file has been created."
    echo "[*] The new KlipperScreen.conf file has been created."
    echo "[*] File owner defined as \"pi\" for all files."
    python3 /home/pi/printer_data/config/scripts/python/addsaveconfig.py
    echo "[*] DONE."
elif [[ $input == "QUIT" || $input == "quit" ]]; then
    echo -e "\n\n"
    echo "[*] NO CHANGES HAVE BEEN MADE."
    exit 0
else
    echo -e "\n\n"
    echo "[?] Invalid command. Choose between \"GO\" or \"QUIT\"."
    echo "[?] And yes. Typing anything other than \"GO\" also exits the script."
    echo -e "\n\n"
    exit 0
fi
