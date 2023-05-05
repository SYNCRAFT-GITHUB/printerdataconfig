#!/bin/bash

echo "
[Syncraft Printer CFG File]

Do you want to copy both the \"backup-printer.cfg\" file
and the \"backup-variables.cfg\" file to the new location,
with the new respective names?

The files will be copied from
> /home/pi/printer_data/config/backup-printer.cfg
> /home/pi/printer_data/config/backup-variables.cfg
to
> /home/pi/printer_data/config/printer.cfg
> /home/pi/printer_data/config/variables.cfg

[!] IF A \"printer.cfg\" FILE ALREADY EXISTS, IT WILL BE OVERWRITTEN!
[!] IF A \"variables.cfg\" FILE ALREADY EXISTS, IT WILL BE OVERWRITTEN!

[*] Type \"GO\" to perform this action, and \"QUIT\" to exit the script.
"

read input

if [[ $input == "GO" || $input == "go" ]]; then
    echo -e "\n\n"
    cp /home/pi/printer_data/config/backup-printer.cfg /home/pi/printer_data/config/printer.cfg
    cp /home/pi/printer_data/config/backup-variables.cfg /home/pi/printer_data/config/variables.cfg
    chown pi /home/pi/printer_data/config/printer.cfg
    chown pi /home/pi/printer_data/config/variables.cfg
    echo "[*] The new printer.cfg file has been created."
    echo "[*] The new variables.cfg file has been created."
    echo "[*] File owner defined as \"pi\" for both files."
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
