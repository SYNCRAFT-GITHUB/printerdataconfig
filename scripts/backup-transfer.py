import os
import shutil

################################################################
###### REMEMBER TO TURN THE BACKUP FILE INTO A CLEAN FILE ######
################################################################
######   /home/pi/printerdataconfig/scripts/transfer.py   ######
################################################################

def transfer_files(source_dir, destination_dir, block_list):
    for root, _, files in os.walk(source_dir):
        for file in files:
            src_file = os.path.join(root, file)
            rel_path = os.path.relpath(src_file, source_dir)
            dst_file = os.path.join(destination_dir, rel_path)
            
            if not any(block_name in rel_path.split(os.sep) for block_name in block_list):
                os.makedirs(os.path.dirname(dst_file), exist_ok=True)
                shutil.copy2(src_file, dst_file)

if __name__ == "__main__":

    # The printerdataconfig path that will be updated over the Internet
    # It will probably be "/home/pi/printerdataconfig"
    source_directory = "/path/"

    # The printerdataconfig path that will be used for Klipper
    # It will probably be "/home/pi/printer_data/config"
    destination_directory = "/path/"

    ############################################################################
    ###### INSERT IN THE ARRAY WHAT SHOULD BE BLOCKED DURING THE TRANSFER ######
    ############################################################################
    ###### * Files must have the extension                                ######
    ###### * Folders can be referenced                                    ######
    ###### * Subfolders cannot be referenced                              ######
    ############################################################################

    block = [""]

    transfer_files(source_directory, destination_directory, block)
    print("[TRANSFER.PY] DONE.")
