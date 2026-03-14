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
- `GN2` NFC IC manufacturer is EM Microelectronic-Marin (`0x17`)
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

Analysis:
- `GA1` Emulating dumped NFC data bit-for-bit (using any UID) results in identical SMART Brick behaviour
- `GA2` The "Darth Vader" minifigures, the "Emperor Palpatine" minifigure, and the Emperor's Throne tag all trigger at least the opening portion of the "Imperial March" to play on the synthesizer.  
  Analyzing their aligned payloads using [biodiff](https://github.com/8051Enthusiast/biodiff) on the output of [json-to-bitstream.py](./scripts/json-to-bitstream.py) *(biodiff settings noted in [001_ResearchEnvironment.md](./010_ResearchEnvironment.md))*, I couldn't find any repeating byte patterns common to all 3 payloads.  
  Repeating analysis by expanding each individual bit to a full byte (`0xFF` or `0x00`) to account for non-byte-aligned programming using [bitstream-as-bytes.py](./scripts/bitstream-as-bytes.py) also showed no repeating bit patterns common to all 3 payloads with the settings I used.

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

&nbsp;



## Conclusions:

Payload anatomy:
- Bytes 0 and 1 of data block 0 are a 16-bit value representing the program size *(currently theoretically between `0x0000` and `0x0108`?)* `[GP2]` `[GP3]`
- Bytes 2 and 3 of data block 0 are a constant value `[GP4]`
- Byte 0 of data block 1 is a constant value `[GP5]`

Metadata:
- Every SMART Tag and SMART Minifigure has its own unique UID `[GM1]`

Analysis:
- The ISO 15693 static NFC payload itself is the only variable to communicate a program to the SMART Brick `[GN1]` `[GA1]`
- All SMART Tags with identical behaviours contain identical binary data, excluding the UID `[TA1]`
- All SMART Minifigures with identical character identities *(regardless of differing outfits, so far)* contain identical binary data, excluding the UID `[MA1]` `[MA2]`
