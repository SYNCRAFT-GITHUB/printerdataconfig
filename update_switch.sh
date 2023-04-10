#!/bin/bash

file=~/printer_data/config/moonraker.conf
text="

[update_manager printerdataconfig]
type: git_repo
path: ~/printer_data/config
origin: https://github.com/SYNCRAFT-GITHUB/printerdataconfig.git
is_system_service: False
"

echo "
[Syncraft Printer Files Update Manager]

Removing the Printer Files from the Update Manager will make it
possible to modify the files using MainSail, however you will no
longer receive Syncraft updates for Printer Configuration related files.

Do you want to Enable or Disable?
[!] Enabling twice WILL cause problems, check before enabling.

"

select action in "Enable" "Disable" "Snoop" "Exit"; do
  case $action in
    Enable)
      echo "[ON] Enabling Syncraft File Updates."
      echo "$text" >> $file
      echo "[!] RESTART MOONRAKER SERVICE OR REBOOT MACHINE TO TAKE EFFECT."
      break
      ;;
    Disable)
      echo "[OFF] Disabling Syncraft File Updates."
      sed -i '/\[update_manager printerdataconfig\]/,/^$/d' $file
      echo "[!] RESTART MOONRAKER SERVICE OR REBOOT MACHINE TO TAKE EFFECT."
      break
      ;;
    Snoop)
      echo "[*] PATH: $file"
      echo "[!] Exiting Script."
      break
      ;;
    Exit)
      echo "[!] Exiting Script."
      break
      ;;
    *)
      echo "[?] Invalid option!"
      ;;
  esac
done
