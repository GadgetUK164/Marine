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
It uses the magic code from the AGA Multifix to control the read resets, write resets, read emables and write enables of the Frame RAM and Line RAM contained on the Amiga 3000 motherboard.  It also works in the GBA1000 from George Braun.
In addition J481 on the 3000 motherboard can be used to enable scanlines in progressive mode.  JP1 and JP2 are added for future changes.   At the time of public release it supports PAL Line RAM only.  It might be possible to use one of the jumpers to toggle between NTSC and PAL Line RAM.   To my knowledge Amiga 3000 computers all shipped with NTSC Line RAM from the factory.  ie. uPD42101.   PAL RAM is uPD42102
Note: There are different speeds of these RAM chips.

So far this has been tested working on:-
Official 3000 Rev 9.x
Re-Amiga 3000
GBA1000
<h1>Important</h1>
The board currently fits into the PLCC footprint using turned pins.   It is recommended to remove the PLCC socket, and fit turned pin (female) strips.
I noticed that when testing PAL Interlaced, using the default 74AL74 (U480) the video is not very sharp at all.  This can be improved massively by swappping U480 on the 3000 to a 74F74.  The GBA1000 already has a 74F74 there.
<br>
The RGB output level to the Commodore Hybrid are at 3.3v level, and whilst testing has revealed the difference to be a negligble amount of brightness difference, it may be an idea to fit a customised modern hybrid in place of HY480.
You can alter the bias resistors (eg. 330 ohm, down from the original 470 ohm).  But in my opinion this is not required.  I've not done it on my 3000, and I cannot see a difference to the output.
As mentioned above, use NTSC Line RAM. uPD42101-3
In future I might be able to support PAL Line RAM.

<h1>Repository Contents</h1>
KiCad PCB Design Files & Schematics
ISE 14.7 VHD and pins files for Logic

<h1>Components Needed</h1>
Xilinx XC95144XL CPLD
R1  0603 Resistor 10K
R2  0603 Resistor 10K
R3  0603 Resistor 10K
R4  0603 Resistor 10K
L1  Ferrite (I went with 9ohm @ 100Mhz)
U1  AMS1117 3.3V Regulator
C1  MLCC Capacitor 4.7uF 10V
C2  MLCC Capacitor 10uF  10V
C3  MLCC Capacitor 1uF   10V
C4  MLCC Capacitor 100nF 10V
2.54 pitch turned pin strips


