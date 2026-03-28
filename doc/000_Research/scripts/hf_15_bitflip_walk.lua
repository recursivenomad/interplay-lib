--      SPDX-License-Identifier: MIT     --
-- Copyright (c) 2026 Peter S. Hollander --
--    <recursivenomad@protonmail.com>    --



-- Walks through every bit of a section of an `hf 15 dump`, provided with "script run hf_15_bitflip_walk.lua <--uid/--payload> <dump.bin>"



local uid_offset = 0 --bytes
local uid_size = 8 --bytes
local uid_variable_size = 4 --bytes

local payload_offset = 175 --bytes
local payload_size = 264 --bytes



local function byte_string(num)
    local str = ""
    for i = 0, 7 do
        str = ((num >> i) & 1) .. str
    end
    return str
end



local function sim(packet, timeout)

    local temp_sim_file = io.open("temp_sim.bin", "wb")
    temp_sim_file:write(string.char(table.unpack(packet)))
    temp_sim_file:close()

    core.console('hf 15 eload --file temp_sim.bin')
    core.console(string.format('hf 15 sim --timeout %i', timeout))

    -- Debug reader activity:
    core.console('hf 15 list')

end



local function main(args_str)

    local args = {}
    local filename
    local packet_offset
    local packet_size

    math.randomseed(os.time())

    for arg in string.gmatch(args_str, "%S+") do
        if (arg == '--help' or arg == '-h') then print("Walks through every bit of a section of an `hf 15 dump`, provided with \"script run hf_15_bitflip_walk.lua <--uid/--payload> <dump.bin>\"") return
        elseif (arg == '--uid' or arg == '-u') then packet_offset = uid_offset; packet_size = uid_size
        elseif (arg == '--payload' or arg == '-p') then packet_offset = payload_offset; packet_size = payload_size
        elseif arg:match(".bin") then filename = arg
        else print(string.format("Unrecognized option \"%s\" - aborting", arg)) return end
    end

    if packet_size == nil then print("No packet type (--uid or --payload) provided - aborting") return end

    local file = io.open(filename, "rb")
    if not file then print("File not found") return end
    local src_data = file:read("*all")
    file:close()

    local src_bytes = { src_data:byte(1,-1) }
    local out_bytes = { src_data:byte(1,-1) }

    io.write("\nConfirming SMART Brick is active...\n")
    sim(src_bytes, 4000)

    for byte = (packet_offset + 1), (packet_offset + packet_size) do

        -- Confirm SMART Brick status every 20 bytes during payload testing (approx. every 5 minutes):
        if (packet_offset == payload_offset) and (((byte-1) % 20) == 0) then
            -- Send unmodified source to confirm SMART Brick is still responding
            io.write(string.format("\nByte %i validation test: 0x%02X\n", byte-1, src_bytes[byte]))
            sim(src_bytes, 4000)
        end

        for bit = 0, 7 do

            out_bytes[byte] = (src_bytes[byte] ~ (1 << bit))

            -- Set custom UID for payload testing so SMART Brick re-downloads the payload
            if packet_offset == payload_offset then
                for i = uid_offset, (uid_variable_size) do
                    out_bytes[i+1] = math.random(0x00, 0xFF)
                end
            end

            io.write(string.format("\nByte %i, bit %i: %02X (%s) -> %02X (%s):\n", byte-1, bit, src_bytes[byte], byte_string(src_bytes[byte]), out_bytes[byte], byte_string(out_bytes[byte])))

            -- I experienced more latency when this was a function call, so we inline it instead
            local temp_sim_file = io.open("temp_sim.bin", "wb")
            temp_sim_file:write(string.char(table.unpack(out_bytes)))
            temp_sim_file:close()

            core.console('hf 15 eload --file temp_sim.bin')
            core.console('hf 15 sim --timeout 1500')

            -- Debug reader activity:
            core.console('hf 15 list')

        end
        -- Debug source payload:
        --io.write(string.format('%02X ', src_bytes[byte]))
    end

end



main(args)
