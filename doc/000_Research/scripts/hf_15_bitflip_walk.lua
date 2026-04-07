--      SPDX-License-Identifier: MIT     --
-- Copyright (c) 2026 Peter S. Hollander --
--    <recursivenomad@protonmail.com>    --



-- Walks through every bit of a section of an `hf 15 dump`, provided with "script run hf_15_bitflip_walk.lua <--uid/--payload> <dump.bin>"

-- Make sure you webcam's automatic adjustments are disabled, and exposure is at minimum
-- Make sure you default audio input device is the piezo-electric pickup
-- Adjust the 2 threshold settings below accordingly

-- This script is messy, but it works :^)


local uid_offset = 0 --bytes
local uid_size = 8 --bytes
local uid_variable_size = 4 --bytes

local payload_offset = 175 --bytes
local payload_size = 264 --bytes

-- Tweak these to accommodate your hardware
local brightness_threshold = 40 --0-255
local loudness_threshold = -15 --dB



local type_validation_check = 1



local video_pipe
local audio_pipe
local brightness_log_pos = 0
local loudness_log_pos = 0



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



local function check_for_response(check_type)

    check_type = check_type or 0

    local brightness_peak = 0
    local brightness_file = io.open("temp_brightness.log", "r")
    brightness_file:seek("set", brightness_log_pos)
    while true do
    	local value = tonumber(brightness_file:read("*line"))
        if not value then break end
        if (value > brightness_peak) then brightness_peak = value end
    end
    brightness_log_pos = brightness_file:seek()
    io.close(brightness_file)

    local loudness_peak = -100
    local loudness_file = io.open("temp_loudness.log", "r")
    loudness_file:seek("set", loudness_log_pos)
    while true do
    	local value = tonumber(loudness_file:read("*line"))
        if not value then break end
        if (value > loudness_peak) then loudness_peak = value end
    end
    loudness_log_pos = loudness_file:seek()
    io.close(loudness_file)

    print("\nBrick stats:")
    print(string.format("Brightness peak:  %i", brightness_peak))
    print(string.format("     Audio peak:  %i", loudness_peak))

    if (check_type == type_validation_check) then

        if ((brightness_peak >= brightness_threshold) and (loudness_peak >= loudness_threshold)) then
            return true
        end

    else

        if ((brightness_peak >= brightness_threshold) or (loudness_peak >= loudness_threshold)) then
            local response_log = io.open("response_bitflip_walk.log", "a")
            response_log:write("====================================\n")
            response_log:write(os.date(), "\n")
            response_log:write("\n")
            response_log:write(string.format("Brightness peak:  %i  (threshold %i)\n", brightness_peak, brightness_threshold))
            response_log:write(string.format("  Loudness peak:  %i  (threshold %i)\n", loudness_peak, loudness_threshold))
            io.close(response_log)
            return true
        end

    end

    return false

end



local function main(args_str)

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

    video_pipe = io.popen("stdbuf -oL ffmpeg -f v4l2 -i /dev/video2 -vf \"signalstats,metadata=print:key=lavfi.signalstats.YMAX\" -f null - 2>&1 | stdbuf -oL sed -n 's/.*YMAX=\\([0-9]*\\).*/\\1/p' > temp_brightness.log &")
    audio_pipe = io.popen("stdbuf -oL ffmpeg -f alsa -i default -af \"asetnsamples=4410,astats=metadata=1:reset=1,ametadata=print:key=lavfi.astats.Overall.Peak_level:direct=1\" -f null - 2>&1 | stdbuf -oL sed -n 's/.*Peak_level=\\(-\\?[0-9]*\\).*/\\1/p' > temp_loudness.log &")

    local src_bytes = { src_data:byte(1,-1) }
    local out_bytes = { src_data:byte(1,-1) }

    io.write("\nConfirming SMART Brick is active...\n")
    sim(src_bytes, 4000)
    local has_response = check_for_response(type_validation_check)
    if not has_response then print("SMART Brick did not respond at initial check-in - aborting") return
    else print("Response is good, continuing") end

    for byte = (packet_offset + 1), (packet_offset + packet_size) do

        -- Confirm SMART Brick status every 10 bytes during payload testing (approx. every 2 minutes):
        if (packet_offset == payload_offset) and (((byte-1) % 10) == 0) then
            -- Send unmodified source to confirm SMART Brick is still responding
            io.write(string.format("\nByte %i validation test: 0x%02X\n", byte-1, src_bytes[byte]))
            sim(src_bytes, 4000)
            local has_response = check_for_response(type_validation_check)
            if not has_response then print(string.format("SMART Brick did not respond at byte %i check-in - aborting", byte-1)) return
            else print("Response is good, continuing") end
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

            local has_response = check_for_response()
            if has_response then

                print("\n\n ! ! ! ! !\n")
                print("RESPONSE DETECTED!")
                print("\n ! ! ! ! !\n\n")
                print("See above information for more details\n\n")

                local response_log = io.open("response_bitflip_walk.log", "a")
                response_log:write("\n")
                response_log:write(string.format("Near byte %i, bit %i: %02X (%s) -> %02X (%s)\n", byte-1, bit, src_bytes[byte], byte_string(src_bytes[byte]), out_bytes[byte], byte_string(out_bytes[byte])))
                response_log:write("\n", args_str, "\n")
                response_log:write("====================================\n\n\n")
                io.close(response_log)

            end

        end

        -- Reset byte to original before continuing the walk
        out_bytes[byte] = src_bytes[byte]

        -- Debug source payload:
        --io.write(string.format('%02X ', src_bytes[byte]))
    end

end



-- Clean up any existing zombie processes
os.execute("killall ffmpeg")
main(args)
video_pipe:close()
audio_pipe:close()
os.execute("killall ffmpeg")
