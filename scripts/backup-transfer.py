import os
import shutil

################################################################
###### REMEMBER TO TURN THE BACKUP FILE INTO A CLEAN FILE ######
################################################################
######   /home/pi/printerdataconfig/scripts/transfer.py   ######
################################################################

saveconfig_line: str = '#*# <---------------------- SAVE_CONFIG ---------------------->'

def transfer_files(source_dir, destination_dir, block_list):
    for root, _, files in os.walk(source_dir):
        for file in files:
            src_file = os.path.join(root, file)
            rel_path = os.path.relpath(src_file, source_dir)
            dst_file = os.path.join(destination_dir, rel_path)
            
            if not any(block_name in rel_path.split(os.sep) for block_name in block_list):
                os.makedirs(os.path.dirname(dst_file), exist_ok=True)
                shutil.copy2(src_file, dst_file)
                os.chmod(dst_file, 0o777)

def save_config_lines(input_file_path, output_file_path):
    saving = False
    config_lines = []

    with open(output_file_path, 'r') as input_file:
        for line in input_file:
            if saveconfig_line in line:
                saving = True
                config_lines.append(line)
            elif saving:
                config_lines.append(line)

    if config_lines:
        with open(output_file_path, 'w') as output_file:
            output_file.writelines(config_lines)

def append_file_contents(input_file_path, output_file_path):

    with open(output_file_path, 'r') as input_file:
        for line in input_file:
            if saveconfig_line in line:
                print (f"[TRANSFER.PY] \"{saveconfig_line}\" detected in {output_file_path}.")
                exit()
    
    with open(input_file_path, 'r') as input_file:
        content_to_append = input_file.read()

    with open(output_file_path, 'a') as output_file:
        output_file.write(content_to_append)


if __name__ == "__main__":

    pdc_git: str = '/home/pi/printerdataconfig'
    pdc_klipper: str = '/home/pi/printer_data/config'
    saveconfig_path: str = f'{pdc_git}/save/saveconfig.txt'
    printercfg_path: str = f'{pdc_klipper}/printer.cfg'

    ############################################################################
    ###### INSERT IN THE ARRAY WHAT SHOULD BE BLOCKED DURING THE TRANSFER ######
    ############################################################################
    ###### * Files must have the extension                                ######
    ###### * Folders can be referenced                                    ######
    ###### * Subfolders cannot be referenced                              ######
    ############################################################################

    # If you want to become a caveman and skip updates, change this variable to True
    caveman = False

    # Array that blocks specific names
    block = ["KlipperScreen.conf", "variables.cfg"]

    if not caveman:
        save_config_lines(printercfg_path, saveconfig_path)
        transfer_files(pdc_git, pdc_klipper, block)
        append_file_contents(saveconfig_path, printercfg_path)
    print("[TRANSFER.PY] DONE.")
