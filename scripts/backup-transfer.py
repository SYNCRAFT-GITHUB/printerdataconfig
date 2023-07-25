import os
import shutil

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
    source_directory = "/path/" 
    destination_directory = "/path/" 
    block = [""]

    transfer_files(source_directory, destination_directory, block)
    print("[TRANSFER.PY] DONE.")
