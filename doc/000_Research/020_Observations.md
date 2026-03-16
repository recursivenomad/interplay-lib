# Research Observations

> [!NOTE]
>
> As stated in the [README](../../README.md), no copyrighted binary assets will be reproduced here; only research findings.



## General

### Methods:

In the Proxmark 3 client, to observe existing NFC data on a SMART Tag / SMART Minifigure:

```
hf 15 dump
```

And to output custom NFC data from the Proxmark 3 to a SMART Brick:

```
hf 15 eload --file <custom-file.json>
hf 15 sim
```

### Findings:

As of the initial release from 1 March 2026, for all SMART Tags and SMART Minifigures...

NFC anatomy:
- `GN1` NFC standard is ISO/IEC 15693
- `GN2` NFC IC manufacturer is EM Microelectronic-Marin (manufacturer code `0x16`, IC code `0x17`)
- `GN3` NFC data is accessible as-is (no authentication handshake needed)
- `GN4` Data is grouped into 66 blocks at 4 bytes per block (264 byte payload)

Payload anatomy:
- `GP1` The later bytes of each program are all padded with `0x00` through to the final byte, with padding beginning at varying positions and rarely being aligned to the start/end of a data block
- `GP2` Byte 0 of data block 0 is always `0x00`
- `GP3` Byte 1 of data block 0 matches the length of the program in bytes (where the program becomes padded with `0x00`)
- `GP4` Bytes 2 and 3 of data block 0 contain a constant value across all programs
- `GP5` Byte 0 of data block 1 also contains a constant value across all programs

Metadata:
- `GM1` UIDs don't appear more than once
- `GM2` All UIDs share the same last (LSB-first) 4 bytes, with the last 2 bytes matching EM Microelectronic-Marin's manufacturer ID (`0x16`) and the ISO 15693 standard byte (`0xE0`)

Analysis:
- `GA1` Emulating dumped NFC data bit-for-bit (using any UID) results in identical SMART Brick behaviour
- `GA2` The "Darth Vader" minifigures *(from [75421](https://www.lego.com/product/75421) and [75427](https://www.lego.com/product/75427))*, the "Emperor Palpatine" minifigure *([75427](https://www.lego.com/product/75427))*, and the Emperor's Throne tag *([75427](https://www.lego.com/product/75427))* all trigger at least the opening portion of the "Imperial March" to play on the synthesizer.  
  Analyzing their aligned payloads using [biodiff](https://github.com/8051Enthusiast/biodiff) on the output of [json-to-bitstream.py](./scripts/json-to-bitstream.py) *(biodiff settings noted in [010_ResearchEnvironment.md](./010_ResearchEnvironment.md))*, I couldn't find any repeating byte patterns common to all 3 payloads.  
  Repeating analysis by expanding each individual bit to a full byte (`0xFF` or `0x00`) to account for non-byte-aligned programming using [bitstream-as-bytes.py](./scripts/bitstream-as-bytes.py) also showed no repeating bit patterns common to all 3 payloads with the settings I used.
- `GA3` Modifying the 8th byte (LSB-first - `0xE0`) of the UID by running [`hf_15_bitflip_walk.lua --uid`](./scripts/hf_15_bitflip_walk.lua) results in the SMART Brick refusing to respond.  
  Modifying any of the other 7 bytes of the UID ***DID NOT*** impact the SMART Brick's response!  
  *(Tested on the program for a "lightsaber dual" tag from [75427](https://www.lego.com/product/75427))*

&nbsp;



## SMART Tags

### Findings:

Analysis:
- `TA1` Comparing 3 "lightsaber dual" SMART Tags: *(1 from [75426](https://www.lego.com/product/75426) and 2 from [75427](https://www.lego.com/product/75427))*  
  All binary data is identical, excluding the UID

&nbsp;



## SMART Minifigures

### Findings:

Analysis:
- `MA1` Comparing the 2 visually identical "Darth Vader" SMART Minifigures: *(from [75421](https://www.lego.com/product/75421) and [75420](https://www.lego.com/product/75420))*  
  All binary data is identical, excluding the UID
- `MA2` Comparing all 5 "Luke Skywalker" SMART Minifigures, consisting of 4 different visual styles: *(from [75420](https://www.lego.com/product/75420), [75422](https://www.lego.com/product/75422), [75423](https://www.lego.com/product/75423), [75426](https://www.lego.com/product/75426), and [75427](https://www.lego.com/product/75427))*  
  All binary data is identical, excluding the UID
- `MA3` All "Luke Skywalker" minifigures *(see above)*, and the "Princess Leia" *([75423](https://www.lego.com/product/75423))*, "Yoda" *([75422](https://www.lego.com/product/75422))*, and "Obi-Wan Kenobi" *([75425](https://www.lego.com/product/75425))* minifigures all play the "Force Theme" in certain situations (such as entering a vehicle) via the synthesizer.  
  Analyzing their aligned payloads using [biodiff](https://github.com/8051Enthusiast/biodiff) on the output of [json-to-bitstream.py](./scripts/json-to-bitstream.py) *(biodiff settings noted in [010_ResearchEnvironment.md](./010_ResearchEnvironment.md))*, I couldn't find any repeating byte patterns common between all 4 payloads.  
  Repeating analysis by expanding each individual bit to a full byte (`0xFF` or `0x00`) to account for non-byte-aligned programming using [bitstream-as-bytes.py](./scripts/bitstream-as-bytes.py) also showed no repeating bit patterns common to all 4 payloads with the settings I used.
- `MA4` The "Luke Skywalker" minifigures and the "Obi-Wan Kenobi" minifigure *(see above)* have programs of identical size (157 bytes), and by extension also share identical 5-byte payload headers.  
  Both minifigures use humanoid speech and include code to play the "Force Theme" on the SMART Brick synthesizer.
  The only difference between them should be subtle pitch changes in their humanoid voice synthesis, yet they share no significant bit- or byte-patterns as mentioned above.

&nbsp;



## Conclusions:

Payload anatomy:
- Bytes 0 and 1 of data block 0 are a 16-bit value representing the program size *(currently theoretically between `0x0005` and `0x0108`?)* `[GP2]` `[GP3]`
- Bytes 2 and 3 of data block 0 are a constant value `[GP4]`
- Byte 0 of data block 1 is a constant value `[GP5]`

Metadata:
- Every SMART Tag and SMART Minifigure has its own unique UID `[GM1]`
- So long as the UID's last byte (LSB-first) is `0xE0`, other bytes of the UID are seemingly irrelevant to SMART Brick compatibility; but it might have future significance to maintain the 7th byte manufacturer code (`0x16`), and the 5th and 6th bytes, which are constant across all current SMART Tags and SMART Minifigures `[GM2]` `[GA3]`

Analysis:
- The ISO 15693 static NFC payload itself is the only variable to communicate a program to the SMART Brick `[GN1]` `[GA1]`
- All SMART Tags with identical behaviours contain identical binary data, excluding the UID `[TA1]`
- All SMART Minifigures with identical character identities *(regardless of differing outfits, so far)* contain identical binary data, excluding the UID `[MA1]` `[MA2]`
