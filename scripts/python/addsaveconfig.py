import os

default_path = os.path.join('/home', 'pi', 'printer_data', 'config')
new_path = os.path.join('/home', 'pi', 'printerdataconfig')

class PATH:
    SOURCE = os.path.join(default_path, 'printer.cfg')
    SAVECONFIG = os.path.join(default_path, 'backups', 'backup-printercfgsaveconfig.txt')
    LEGACY = os.path.join(new_path, 'legacy.txt')
    EXTRACTED = os.path.join(new_path, 'backups', 'extract-saveconfig.txt')
    MOONRAKER = os.path.join(default_path, 'moonraker.conf')

saveconfig_line: str = '#*# <---------------------- SAVE_CONFIG ---------------------->'
saveconfig_backup: str = """
#*# <---------------------- SAVE_CONFIG ---------------------->
#*# DO NOT EDIT THIS BLOCK OR BELOW. The contents are auto-generated.
#*#
#*# [probe]
#*# z_offset = -0.300
#*#
#*# [stepper_z]
#*# position_endstop = 340.25
"""

if os.path.exists(PATH.EXTRACTED):
    PATH.SAVECONFIG = f"{PATH.EXTRACTED}"

name = "[ADD SAVE CONFIG]"

with open(PATH.SOURCE, 'r') as source_file:
    source_content = source_file.readlines()
    print (f"{name} source file path: {PATH.SOURCE}.")

with open(PATH.SAVECONFIG, 'r') as saveconfig_file:
    saveconfig_content = saveconfig_file.readlines()
    print (f"{name} saveconfig file path: {PATH.SAVECONFIG}.")

    duplicateSaveConfig: bool = False
    hasSaveConfigLine: bool = False

    for line in source_content:
        if saveconfig_line in line:
            duplicateSaveConfig = True

    for line in saveconfig_content:
        if saveconfig_line in line:
            print (f"{name} 'Save Config Line' found in extracted file.")
            hasSaveConfigLine = True

    if not hasSaveConfigLine:
        print (f"{name} 'Save Config Line' not found in extracted file. Using backup...")
        saveconfig_content = []
        for i, line in enumerate(saveconfig_backup):
            try:
                saveconfig_content.append(saveconfig_backup[i])
            except:
                pass

combined_content = source_content + ["\n"] + saveconfig_content

if not duplicateSaveConfig:
    with open(PATH.SOURCE, 'w') as new_file:
        new_file.writelines(combined_content)
        print (f"{name} the new file replaced the source file.")
else:
    print (f"{name} duplicate saveconfig line detected. skip merge.")

def replace_and_overwrite(file_path):
    with open(file_path, "r") as file:
        content = file.read()
    
    new_content = content.replace(default_path, new_path)
    
    with open(file_path, "w") as file:
        file.write(new_content)

if os.path.exists(PATH.LEGACY):
    with open(PATH.LEGACY, "r") as file:
        file_content = file.read().strip()
    
    if file_content == "false":
        replace_and_overwrite(PATH.MOONRAKER)
        print(f"{name} replaced printerdataconfig moonraker path.")
    else:
        print(f"{name} system detected as legacy.")
else:
    replace_and_overwrite(PATH.MOONRAKER)
    print(f"{name} replace printerdataconfig moonraker path.")
    print(f"{name} legacy file don't exist. acting as non-legacy system")
    print(f"{name} replaced printerdataconfig moonraker path.")

try:
    os.system('sudo service klipper restart')
    print(f"{name} klipper service restarted.")
except:
    print(f"{name} can't restart klipper service.")
    pass