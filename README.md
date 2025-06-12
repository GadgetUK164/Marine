<h1>Marine (Amber Replacement)</h1>
Marine is a modern CPLD replacement, designed to replace the Amber chip in the Commodore Amiga.
This project is based on the work of Matthias Heinrichs - AGA Multifix.
You can see his original project here:- https://gitlab.com/MHeinrichs/multifix-aga/-/tree/master

A massive thanks to Matthias for creating the AGA Multifix, and for allowing me to adapt to an Amber replacement.

![20250608_175438](https://github.com/user-attachments/assets/77b75f60-ae52-479e-ad04-98aac9ea0a00)

<h1>License</h1>
This project is open source, and should not be sold commercially.

Do whatever you want with this, if you do it for private use and mention this work, and the AGA Multifix as origin.
If you want to make money out of this work, ask Matthias Heinrichs.
If you copy parts of this work to your project, mention the source.
If you use parts of this work for closed source, burn in hell and live in fear!

<h1>How Does It Work</h1>
It uses the magic code from the AGA Multifix to control the read resets, write resets, read emables and write enables of the Frame RAM and Line RAM contained on the Amiga 3000 motherboard.  It also works in the GBA1000 from George Braun.
In addition J481 on the 3000 motherboard can be used to enable scanlines in progressive mode.  JP1 and JP2 are added for future changes.   At the time of public release it supports PAL Line RAM only.  It might be possible to use one of the jumpers to toggle between NTSC and PAL Line RAM.<br><br>   To my knowledge Amiga 3000 computers all shipped with NTSC Line RAM from the factory.  ie. uPD42101.   PAL RAM is uPD42102<br><br>
Note: There are different speeds of these RAM chips.
<br>
So far this has been tested working on:-
<ul>
<li>Official 3000 Rev 9.x</li>
<li>Re-Amiga 3000</li>
<li>GBA1000</li>
</ul>
<h1>Important</h1>
The current board revision is RC2 - I have NOT tested that revision yet!  Difference between RC1 and RC2 - RC2 moved the capacitor on the 3.3v rail to the left side, and PCB cut away slightly to allow fitment better in the 3000.  I also added a pull up on the J481 "pin".
The board currently fits into the PLCC footprint using turned pins.   It is recommended to remove the PLCC socket, and fit turned pin (female) strips.
I noticed that when testing PAL Interlaced, using the default 74AL74 (U480) the video is not very sharp at all.  This can be improved massively by swappping U480 on the 3000 to a 74F74.  The GBA1000 already has a 74F74 there.
<br>
The RGB output level to the Commodore Hybrid are at 3.3v level, and whilst testing has revealed the difference to be a negligble amount of brightness difference, it may be an idea to fit a customised modern hybrid in place of HY480.
You can alter the bias resistors (eg. 330 ohm, down from the original 470 ohm).  But in my opinion this is not required.  I've not done it on my 3000, and I cannot see a difference to the output.
As mentioned above, use NTSC Line RAM. uPD42101-3
In future I might be able to support PAL Line RAM.

<h1>Repository Contents</h1>
KiCad 7.0 PCB Design Files & Schematics
<br>
ISE 14.7 VHD and pins files for Logic

<h1>Components Needed</h1>
Xilinx XC95144XL CPLD<br>
R1  0603 Resistor 10K<br>
R2  0603 Resistor 10K<br>
R3  0603 Resistor 10K<br>
R4  0603 Resistor 10K<br>
L1  0805 Ferrite (I went with 9ohm @ 100Mhz)<br>
U1  SOT-223 AMS1117 3.3V Regulator<br>
C1  0805 MLCC Capacitor 4.7uF 10V<br>
C2  0805 MLCC Capacitor 10uF  10V<br>
C3  0805 MLCC Capacitor 1uF   10V<br>
C4  0805 MLCC Capacitor 100nF 10V<br>
2.54 pitch turned pin strips<br>

<h1>Limitations</h1>
I offer no warranty on this design.  It works for me, and I am happy!
If you have a problem, I can investigate - but this is a hobby project.<br>
Super Hires will display, but not correctly.  The RAM used on the Amiga 3000 cannot hold 1200 pixels wide, so some sampling issues will be noticed when trying to display Super Hires.
I have tested many games and demos that use either interlaced or progressive and found no problems.<br><br>
Video modes supported by Super Denise (ECS) are not supported (as per Amber).
The bypass switch on the 3000 has been tested and works as per Amber original manual bypass.
J481 is not supported as per the original Amber, partly because I couldnt work out how it was used!  It now can be used to enable or disable scanlines in progressive display modes.<br><br>
I found it harder to "dial in" regards the Amiga 3000 PLL adjustment (trim cap and resistor).  This could indicate that my timing is not spot on just yet.  That was NOT the case with the Re-Amiga 3000, or the GBA1000.  PLL adjustment on those systems was much easier for me.  It may benefit from a re-design to add:-<br>
<br>
<ul>
<li>More decoupling on CPLD power pins?</li>
<li>Buffering of RGB to TTL levels?</li>
<li>Schmitt Triggers on 14Mhz and 28Mhz inputs?</li>
<li>4 layer?</li>
<li>PLCC plug (seperate interposer might be possible)?</li>
</ul>

