<h1>Marine (Amber Replacement)</h1>
Marine is a modern CPLD replacement, designed to replace the Amber chip in the Commodore Amiga.
This project is based on the work of Matthias Heinrichs - AGA Multifix.
You can see his original project here:- https://gitlab.com/MHeinrichs/multifix-aga/-/tree/master

A massive thanks to Matthias for creating the AGA Multifix, and for allowing me to adapt to an Amber replacement.

![20250608_175438](https://github.com/user-attachments/assets/77b75f60-ae52-479e-ad04-98aac9ea0a00)


![top](https://github.com/user-attachments/assets/8b1fe512-9a9e-43a3-af80-650c5f3efa30)
![bottom](https://github.com/user-attachments/assets/4a0c8d69-558a-4da8-9f5b-4be827701c2f)


<h1>License</h1>
This project is open source, and should not be sold commercially.

Do whatever you want with this, if you do it for private use and mention this work, and the AGA Multifix as origin.
If you want to make money out of this work, ask Matthias Heinrichs.
If you copy parts of this work to your project, mention the source.
If you use parts of this work for closed source, burn in hell and live in fear!

<h1>How Does It Work</h1>
It uses the magic code from the AGA Multifix to control the read resets, write resets, read enables and write enables of the Frame RAM and Line RAM contained on the Amiga 3000 motherboard.  It also works in the GBA1000 from Georg Braun.
JP1 and JP2 are added for future changes.   At the time of public release it supports NTSC Line RAM only.  It may be possible with a future firmware update, to use one of the jumpers to toggle between NTSC and PAL Line RAM.<br><br>   To my knowledge Amiga 3000 computers all shipped with NTSC Line RAM from the factory.  ie. uPD42101.   PAL RAM is uPD42102<br><br>
Note: There are different speeds of these RAM chips.  So far this has been tested working correctly with uPD42101-3 Line RAM.<br>
<ul>
<li>Official 3000 Rev 9.x</li>
<li>Re-Amiga 3000</li>
<li>GBA1000</li>
</ul>
Note: You could in theory use 2 x PAL Line RAM, and 2 x NTSC Line RAM chips.  The ones on the combined "path" need to be NTSC.<br><br>
In addition J481 on the 3000 motherboard can be used to enable scanlines in progressive mode.  Before anyone asks, it's not practical to have scanlines in interlaced modes - additional pixel data is contained in interlaced.  In progressive, each scanline just gets output twice, so a black scanline for the odd scanlines makes sense!<br><br>
<h1>Important</h1>
The current board revision is RC2 - I have NOT tested that revision yet!  Difference between RC1 and RC2 - RC2 moved the C1 capacitor to the left side (away from cut out section), and PCB cut away slightly to allow fitment better in the 3000.  I also added a pull up resistor (R4) on the J481 IO related pin on the CPLD.<br><br>
The board currently fits into the PLCC footprint using turned pins.   It is recommended to remove the PLCC socket, and fit turned pin (female) strips to the motherboard.  Then fit turned pin (male) strips to the Marine PCB.<br><br>
I noticed that when testing PAL Interlaced on the Amiga 3000 using the default 74ALS74 (U480) which Commodore fitted to the motherboard, the video is not very sharp at all.  This can be improved massively by swappping U480 on the 3000 to a 74F74.  The GBA1000 already has a 74F74 in that location.
<br><br>
The RGB output levels to the Commodore Hybrid are at the 3.3v logic levels, and whilst testing has revealed the difference to be a negligble amount of effect on brightness, it may be an idea to fit a customised modern hybrid in place of HY480.
You can alter the bias resistors on a modern Hyrid replacement (eg. to 330 ohm, down from the original 470 ohm).  But in my opinion this is not required.  I've not done it on my 3000, and I honestly cannot see a difference to the output.  If I scope it, I am sure there will be a difference though!<br><br>
As mentioned above, use NTSC Line RAM (uPD42101-3).<br>
In future I might be able to support PAL Line RAM via a code change and use of either JP1 or JP2.

<h1>Repository Contents</h1>
KiCad 7.0 PCB Design Files & Schematics
<br>
ISE 14.7 VHD and pins files for Logic

<h1>Components Needed</h1>
<ul>
<li>Xilinx XC95144XL-10TQ100 CPLD</li>
<li>R1  0603 Resistor 10K</li>
<li>R2  0603 Resistor 10K</li>
<li>R3  0603 Resistor 10K</li>
<li>R4  0603 Resistor 10K</li>
<li>L1  0805 Ferrite (I went with 9ohm @ 100Mhz) - You could just fit 0ohm or 1ohm here I think!</li>
<li>U1  SOT-223 AMS1117 3.3V Regulator</li>
<li>C1  0805 MLC Capacitor 4.7uF 50V</li>
<li>C2  0805 MLC Capacitor 10uF  50V</li>
<li>C3  0805 MLC Capacitor 1uF   50V</li>
<li>C4  0805 MLC Capacitor 100nF 50V</li>
<li>2.54 pitch turned pin strips (female for motherboard, male for Marine)</li>
</ul>

<h1>Limitations</h1>
I offer no warranty on this design.  It works for me, and I am happy!
If you have a problem, I can investigate - but this is a hobby project.<br>
Super Hires will display, but not 100% correctly - it can look pretty good but a pixel will be missed every so often due to sampling into smaller RAM at a lower clock rate than required.  The RAM used on the Amiga 3000 cannot hold 1200 pixels of a scanline, so some sampling issues will be noticed when trying to display Super Hires.
I have tested many games and demos that use either interlaced or progressive and found no problems.<br><br>
Video modes supported by Super Denise (ECS) are not supported (as per Amber).
The bypass switch on the 3000 has been tested and works as per Amber original manual bypass.
J481 is not supported as per the original Amber, partly because I couldnt work out how it was used!  It now can be used to enable or disable scanlines in progressive display modes.<br><br>
I found it harder to "dial in" regards the Amiga 3000 PLL adjustment (trim cap and resistor).  That was NOT the case with the Re-Amiga 3000, or the GBA1000.  PLL adjustment on those systems was much easier for me. <br><br>
NTSC interlaced display modes are definitely sharper than PAL interlaced ones, just marginally!  This could indicate that my timing is not spot on just yet!<br><br>
It may benefit from a re-design to add:-<br>
<br>
<ul>
<li>More decoupling on CPLD power pins?</li>
<li>Buffering of RGB output to TTL levels?</li>
<li>Schmitt Triggers on 14Mhz and 28Mhz inputs?</li>
<li>4 layer?</li>
<li>PLCC plug (separate interposer might be possible)?</li>
</ul>

