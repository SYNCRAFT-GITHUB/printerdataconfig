source_file_path = "/home/pi/printer_data/config/printer.cfg"
saveconfig_file_path = "/home/pi/printer_data/config/backups/backup-printercfgsaveconfig.txt"
new_file_path = "/home/pi/printer_data/config/printer.cfg"

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