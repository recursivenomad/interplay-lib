# Research Environment



This research environment consists of:

- [Proxmark3 RDV4](https://proxgrind.com/prototyping/proxmark3-rdv4-0-development/)
- Iceman client & firmware *([v4.21128](https://github.com/RfidResearchGroup/proxmark3/tree/v4.21128))*  
  *Built using Debian 12 and per the repository's documentation*
- Python 3 for running scripts
- [biodiff](https://github.com/8051Enthusiast/biodiff) for comparing binary files  
  > *For binary files, I found the following settings helpful for byte pattern recognition:*  
  > *Global | Gap Open: -5 | Gap Extend: 0 | Mismatch: -1 | Match: 4 | Backend: rustbio*  
  > *And for inflated files where each bit inflates to either `0x00` or `0xFF`, these were servicable:*  
  > *Global | Gap Open: -13 | Gap Extend: 0 | Mismatch: -3 | Match: 1 | Backend: rustbio*
- All initial-release LEGO® SMART Play™ sets: *(released March 1st, 2026)*  
  [75420](https://www.lego.com/product/75420) | [75421](https://www.lego.com/product/75421) | [75422](https://www.lego.com/product/75422) | [75423](https://www.lego.com/product/75423) | [75424](https://www.lego.com/product/75424) | [75425](https://www.lego.com/product/75425) | [75426](https://www.lego.com/product/75426) | [75427](https://www.lego.com/product/75427)



&nbsp;

> ### Failed attempts
>
> - The [Chameleon Ultra](https://github.com/RfidResearchGroup/ChameleonUltra) does not have firmware/codec support for the ISO 15693 standard that the SMART Tags appear to use. *(ISO 15693 initially confirmed via smartphone [NFC Tools](https://play.google.com/store/apps/details?id=com.wakdev.wdnfc) and [NFC TagInfo by NXP](https://play.google.com/store/apps/details?id=com.nxp.taginfolite))*
