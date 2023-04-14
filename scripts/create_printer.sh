#!/bin/bash

echo "
[Syncraft Printer CFG File]

Do you want to copy the \"backup-printer.cfg\" file
to the new location, with the new name \"printer.cfg\"?

The file will be copied from
/home/pi/printer_data/config/backup-printer.cfg
to
/home/pi/printer_data/config/printer.cfg

[!] IF A \"printer.cfg\" FILE ALREADY EXISTS, IT WILL BE OVERWRITTEN!

[*] Type \"GO\" to perform this action, and \"QUIT\" to exit the script.
"

read input

if [[ $input == "GO" || $input == "go" ]]; then
    echo -e "\n\n"
    cp /home/pi/printer_data/config/backup-printer.cfg /home/pi/printer_data/config/printer.cfg
    echo "[*] SUCCESS."
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
