source_file_path = "/home/pi/printer_data/config/printer.cfg"
backup_file_path = "/home/pi/printer_data/config/backups/backup-printer.cfg"
new_file_path = "/home/pi/printer_data/config/printer.cfg"

script_name = "[PRINTER WATCHDOG]"

# Step 1: Read the source text file
with open(source_file_path, 'r') as source_file:
    source_content = source_file.readlines()
    print (f"{script_name} source file path: {source_file_path}.")

# Step 2: Read the backup file
with open(backup_file_path, 'r') as backup_file:
    backup_content = backup_file.readlines()
    print (f"{script_name} backup file path: {backup_file_path}.")

# Step 3: Filter the source content
filtered_content = [line for line in source_content if "#*#" in line]
print (f"{script_name} source content filtered.")

# Step 4: Create the new variable with combined content
combined_content = backup_content + ["\n", "\n"] + filtered_content
print (f"{script_name} the new file was built.")

# Step 5: Save the combined content to a new file
with open(new_file_path, 'w') as new_file:
    new_file.writelines(combined_content)
    print (f"{script_name} the new file replaced the source file.")
    print (f"{script_name} OK.")
