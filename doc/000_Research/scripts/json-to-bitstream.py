#       SPDX-License-Identifier: MIT      #
#  Copyright (c) 2026 Peter S. Hollander  #
#     <recursivenomad@protonmail.com>     #



# Attempts to convert all .json files in the current working directory to a bitstream of ISO 15693 NFC, payload only
# Assumes all .json files are Proxmark 3 formatted outputs



import json
import glob


input_files = glob.glob('*.json')

file_count = 0


for in_file_path in input_files:

    out_file_path = file_path.replace('.json', '.payload')

    try:
        with open(in_file_path, 'r') as file_in, open(out_file_path, 'wb') as file_out:
            data = json.load(file_in)

            blocks = data["blocks"]

            payload = []

            #print(f"Converting {in_file_path}")

            for block, value in blocks.items():
                block_array = list(bytes.fromhex(value))
                payload.extend(block_array)

            file_out.write(bytes(payload))

            file_count += 1

    except json.JSONDecodeError:
        print(f"Error: Failed to read JSON file: {in_file_path}")


print(f"{file_count} payloads converted to raw bitstream")
