import os
import shutil

def transfer_files(source_dir, destination_dir):
    for root, _, files in os.walk(source_dir):
        for file in files:
            src_file = os.path.join(root, file)
            rel_path = os.path.relpath(src_file, source_dir)
            dst_file = os.path.join(destination_dir, rel_path)

            os.makedirs(os.path.dirname(dst_file), exist_ok=True)
            shutil.copy2(src_file, dst_file)
            os.chmod(dst_file, 0o777)

if __name__ == "__main__":

    source_directory = "/home/pi/printerdataconfig"
    destination_directory = "/home/pi/printer_data/config"

    transfer_files(source_directory, destination_directory)
    print("[first-transfer.py] DONE.")
