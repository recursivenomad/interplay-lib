**Interplay: Community NFC Interaction Library** 🔃
===================================================


### *Unofficial NFC library for interoperability with LEGO® SMART Play™ hardware*


### [Issues](https://gitlab.com/recursivenomad/interplay-lib/-/issues) | [Merge requests](https://gitlab.com/recursivenomad/interplay-lib/-/merge_requests) | [Releases](https://gitlab.com/recursivenomad/interplay-lib/-/releases)


[![](../../../gitlab-redirect/raw/main/redirect.png)][URL-Repository]


> [!IMPORTANT]
> 
> **Intellectual Property Notice**
> 
> This project's sole purpose is to document, learn from, and experiment with the observable communication protocols used in the LEGO® SMART Play™ system, in order to facilitate research and interoperability between independently created software and SMART Play™ hardware.
> 
> This project will never host nor distribute proprietary encryption keys or copyrighted binary assets, and will never provide tools which are meant to circumvent such protections.
> 
> All research is performed on legally purchased, publicly available hardware.

&nbsp;

> [!WARNING]
> 
> Allowing your LEGO® SMART Brick(s) to interface with any code featured in this repository is not supported or endorsed by the LEGO Group in any way - engage with this research at your own risk!

&nbsp;





***Foreword***
==============

I am choosing to first begin this project in isolation of others' inevitable research efforts to keep foundations clean, with hopes that future cross-referencing across teams will be able to validate and strengthen respectively-independent findings.

So long as you respect the intellectual property notice above, feel free to contribute with issues, ideas, or license-compliant merge requests! 🙂

(For licensing reasons, I will not accept LLM-assisted code at this time)

&nbsp;





***Plans***
===========

- [x] ~~Obtain the first wave of LEGO® SMART Play™ sets for observation and study~~  
  *~~(pre-orders ship March 1st, 2026)~~*
- [ ] Observe & document existing NFC communications in this initial release  
  *~~(Chameleon Ultra did not support ISO 15693)~~*  
  *(Proxmark3 expected to arrive by 13 March, 2026...)*
- [ ] Determine whether identical tags share identical NFC data
- [ ] Confirm that isolating identical NFC data results in identical SMART Brick behaviour  
  *ie. establish that NFC data itself is the only variable in this protocol*
- [ ] Determine whether NFC data is encrypted
  - [ ] If so, is data structure & functional protocol analysis possible?
- [ ] Investigate & document any extensibility built into the protocol that supports independently created software

&nbsp;






***Further Reading***
=====================

> Technical deep dives:
> - https://www.wired.com/story/exclusive-inside-look-at-new-lego-smart-brick/
> - https://www.lego.com/smart-play/article/innovation
> - https://www.lego.com/live/smart-play

> Additional research & teardowns:
> *(Waiting to include other NFC-related research projects until this project establishes its initial findings)*
> - https://www.youtube.com/watch?v=VcAytfrHL20
> - https://www.reddit.com/r/LegoSmartBrick/comments/1rkkojk/  
>   *(contains LLM summary, watch out for hallucinations)*
> - https://blog.adafruit.com/2026/03/06/some-lego-smart-brick-ble-reverse-engineering/  
>   *(feels like LLM composition - assume some hallucinations)*

> Other official LEGO® web pages:
> - https://www.lego.com/aboutus/news/2026/december/lego-smart-play-announcement
> - https://www.lego.com/smart-play
> - https://www.lego.com/smart-play/all-sets
> - https://www.lego.com/smart-play/app-video
> - https://www.lego.com/smart-play/getting-started
> - https://www.lego.com/smart-play/guide
> - https://www.lego.com/smart-play/article/play-together
> - https://www.lego.com/service/help-topics/category/smart-play
> - https://play.google.com/store/apps/details?id=com.lego.smartassist

> LEGO® trademark usage guidelines:
> - https://www.lego.com/legal/notices-and-policies/fair-play
> - https://www.lego.com/cdn/cs/legal/assets/blt1a4c9a959ce8e1cb/LEGO_Fairplay_Nov2018.pdf

&nbsp;






***License***
=============

This work is made freely available under the [MIT license](./LICENSE.txt).  
Only attribution is required, but open-sourcing when you make something with my work is really cool too ❤️✨

*LEGO and SMART Play are trademarks of the LEGO Group which does not sponsor, authorize, or endorse this project.*

----------------------

*Repository: <https://gitlab.com/recursivenomad/interplay-lib/>*  
*Contact: <recursivenomad@protonmail.com>*

----------------------






[URL-MIT]: <https://opensource.org/license/mit/>

[URL-Repository]: <https://gitlab.com/recursivenomad/interplay-lib/>
