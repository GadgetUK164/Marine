<h1>Marine (Amber Replacement)</h1>
Marine is a modern CPLD replacement, designed to replace the Amber chip in the Commodore Amiga.
This project is based on the work of Matthias Heinrichs - AGA Multifix.
You can see his original project here:- https://gitlab.com/MHeinrichs/multifix-aga/-/tree/master

A massive thanks to Matthias for creating the AGA Multifix, and for allowing me to adapt to an Amber replacement.

<h1>License</h1>
This project is open source, and should not be sold commercially.

Do whatever you want with this, if you do it for private use and mention this work, and the AGA Multifix as origin.
If you want to make money out of this work, ask Matthias Heinrichs.
If you copy parts of this work to your project, mention the source.
If you use parts of this work for closed source, burn in hell and live in fear!

<h1>How Does It Work</h1>
It uses the magic code from the AGA Multifix to control the read resets, write resets, read emables and write enables of the frame and line RAM contained on the Amiga 3000 motherboard.  It also works in the GBA1000 from George Braun.
In addition J481 on the 3000 motherboard can be used to enable scanlines in progressive mode.  JP1 and JP2 are added for future changes.   At the time of public release it supports PAL Line RAM only.  It might be possible to use one of the jumpers to toggle between NTSC and PAL Line RAM.   To my knowledge Amiga 3000 computers all shipped with NTSC Line RAM from the factory.  ie. uPD42101.   PAL RAM is uPD42102
Note: There are different speeds of these RAM chips.

So far this has been tested working on:-
Official 3000 Rev 9.x
Re-Amiga 3000
GBA1000


