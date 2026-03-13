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

### Findings:

- SMART Tag and SMART Minifigure UIDs don't appear more than once

### Conclusions:

- Every SMART Tag and SMART Minifigure has its own unique UID

&nbsp;



## SMART Tags

> [!NOTE]
>
> As stated in the [README](../../README.md), no copyrighted binary assets will be reproduced here; only research findings.

### Findings:

- Comparing 3 "lightsaber dual" SMART Tags: *(1 from [75426](https://www.lego.com/product/75426) and 2 from [75427](https://www.lego.com/product/75427))*  
  All binary data is identical, excluding the UID

### Conclusions:

- All SMART Tags with identical behaviours contain identical binary data, excluding the UID

&nbsp;



## SMART Minifigures

> [!NOTE]
>
> As stated in the [README](../../README.md), no copyrighted binary assets will be reproduced here; only research findings.

### Findings:

- Comparing the 2 visually identical "Darth Vader" SMART Minifigures: *(from [75421](https://www.lego.com/product/75421) and [75420](https://www.lego.com/product/75420))*  
  All binary data is identical, excluding the UID
- Comparing all 5 "Luke Skywalker" SMART Minifigures, consisting of 4 different visual styles: *(from [75420](https://www.lego.com/product/75420), [75422](https://www.lego.com/product/75422), [75423](https://www.lego.com/product/75423), [75426](https://www.lego.com/product/75426), and [75427](https://www.lego.com/product/75427))*  
  All binary data is identical, excluding the UID

### Conclusions:

- All SMART Minifigures with identical character identities *(regardless of changes in appearance, so far)* contain identical binary data, excluding the UID
