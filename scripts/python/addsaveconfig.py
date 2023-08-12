import os

default_path: str = "/home/pi/printer_data/config"

source_file_path = f"{default_path}/printer.cfg"
saveconfig_file_path = "{default_path}/backups/backup-printercfgsaveconfig.txt"
new_file_path = "{default_path}/printer.cfg"
legacy_file_path = "/home/pi/printerdataconfig/legacy.txt"
extracted_saveconfig_path = "/home/pi/printerdataconfig/backups/extract-saveconfig.txt"

if os.path.exists(extracted_saveconfig_path):
    saveconfig_file_path = f"{extracted_saveconfig_path}"

script_name = "[ADD SAVE CONFIG]"

with open(source_file_path, 'r') as source_file:
    source_content = source_file.readlines()
    print (f"{script_name} source file path: {source_file_path}.")

with open(saveconfig_file_path, 'r') as saveconfig_file:
    saveconfig_content = saveconfig_file.readlines()
    print (f"{script_name} saveconfig file path: {saveconfig_file_path}.")

combined_content = source_content + ["\n", "\n"] + saveconfig_content
print (f"{script_name} the new file was built.")

with open(new_file_path, 'w') as new_file:
    new_file.writelines(combined_content)
    print (f"{script_name} the new file replaced the source file.")
    print (f"{script_name} OK.")

def replace_and_overwrite(file_path):
    with open(file_path, "r") as file:
        content = file.read()
    
    new_content = content.replace("~/printer_data/config", "~/printerdataconfig")
    
    with open(file_path, "w") as file:
        file.write(new_content)

if os.path.exists(legacy_file_path):
    with open(legacy_file_path, "r") as file:
        file_content = file.read().strip()
    
    if file_content == "false":
        replace_and_overwrite("/home/pi/printer_data/config/moonraker.conf")
        print(f"{script_name} replaced printerdataconfig moonraker path.")
    else:
        print(f"{script_name} system detected as legacy.")
else:
    replace_and_overwrite("/home/pi/printer_data/config/moonraker.conf")
    print(f"{script_name} replace printerdataconfig moonraker path.")
    print(f"{script_name} legacy file don't exist. acting as non-legacy system")
    print(f"{script_name} replaced printerdataconfig moonraker path.")