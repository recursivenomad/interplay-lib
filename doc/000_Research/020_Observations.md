# Research Observations


## General

All NFC communications appear to follow the ISO/IEC 15693 standard for contactless vicinity objects.  
This standard itself allows for a maximum range of up to 1-1.5 meters.

### Methods:

In the Proxmark 3 client, to observe existing NFC data on a SMART Tag / SMART Minifigure:

```
hf 15 dump
```

And to output custom NFC data from the Proxmark 3 to a SMART Brick:

```
hf 15 eload --file <custom-file.bin>
hf 15 sim
```
