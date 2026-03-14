#       SPDX-License-Identifier: MIT      #
#  Copyright (c) 2026 Peter S. Hollander  #
#     <recursivenomad@protonmail.com>     #



# Attempts to inflate every bit in all .payload files in the current working directory to a full byte each for analysis



import json
import glob


input_files = glob.glob('*.payload')

file_count = 0


for in_file_path in input_files:

    out_file_path = in_file_path.replace('.payload', '.inflated')

    with open(in_file_path, 'rb') as file_in, open(out_file_path, 'wb') as file_out:
        payload = file_in.read()

        payload_inflated = []

        #print(f"Inflating {in_file_path}")

        for byte in payload:
            binary_string = f"{byte:08b}"
            for bit in binary_string:
                payload_inflated.append(int(bit) * 0xFF)

        file_out.write(bytes(payload_inflated))

        file_count += 1


print(f"{file_count} payloads inflated each bit to a full byte")
