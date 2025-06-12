----------------------------------------------------------------------------------
-- Company: 			N/A
-- Engineer: 			GadgetUK (YouTube)
-- 
-- Create Date:    	17:16:57 05/07/2025
-- Last Update:		23:54:00 17/05/2025
-- Design Name:	 	Marine
-- Module Name:    	main - Behavioral 
-- Project Name: 
-- Target Devices:	xc9572xl-10TQ100 / xc95144xl-10TQ100
-- Tool versions: 	ISE 14.7
-- Description: 
-- Commodore Amiga Amber replacement
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
-- Original code courtesy of Mattias Heinrichs, from his AGA Multifix Project.
-- 95% of this code is code from Mattias Heinrichs.  Very few changes required.
-- Check out the original source (AGA Multifix) - https://gitlab.com/MHeinrichs/multifix-aga
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity main is
    Port ( 
	         -- RGB INPUTS (FROM DENISE)
				RIN0       : in STD_LOGIC;
				RIN1       : in STD_LOGIC;
				RIN2       : in STD_LOGIC;
				RIN3       : in STD_LOGIC;

				GIN0		  : in STD_LOGIC;
				GIN1		  : in STD_LOGIC;
				GIN2		  : in STD_LOGIC;
				GIN3		  : in STD_LOGIC;
				
				BIN0       : in STD_LOGIC;
				BIN1       : in STD_LOGIC;
				BIN2       : in STD_LOGIC;
				BIN3       : in STD_LOGIC;
				
				--RGB OUTPUTS (TO DAC)
				ROUT0  	  : out STD_LOGIC;
				ROUT1  	  : out STD_LOGIC;
				ROUT2  	  : out STD_LOGIC;
				ROUT3  	  : out STD_LOGIC;
				
				GOUT0      : out STD_LOGIC;
				GOUT1      : out STD_LOGIC;
				GOUT2      : out STD_LOGIC;
				GOUT3      : out STD_LOGIC;
				
				BOUT0      : out STD_LOGIC;
				BOUT1      : out STD_LOGIC;
				BOUT2      : out STD_LOGIC;
				BOUT3      : out STD_LOGIC;
				
				--RGB DELAYED
				RD0	 	 : in STD_LOGIC;
				RD1	 	 : in STD_LOGIC;
				RD2	 	 : in STD_LOGIC;
				RD3	 	 : in STD_LOGIC;
				
				GD0       : in STD_LOGIC;
				GD1       : in STD_LOGIC;
				GD2       : in STD_LOGIC;
				GD3       : in STD_LOGIC;
				
				BD0       : in STD_LOGIC;
				BD1       : in STD_LOGIC;
				BD2       : in STD_LOGIC;
				BD3       : in STD_LOGIC;
				
				--RGB COMBINED
				RC0	 	 : in STD_LOGIC;
				RC1	 	 : in STD_LOGIC;
				RC2	 	 : in STD_LOGIC;
				RC3	 	 : in STD_LOGIC;
				
				GC0       : in STD_LOGIC;
				GC1       : in STD_LOGIC;
				GC2       : in STD_LOGIC;
				GC3       : in STD_LOGIC;
				
				BC0       : in STD_LOGIC;
				BC1       : in STD_LOGIC;
				BC2       : in STD_LOGIC;
				BC3       : in STD_LOGIC;
				
				-- INPUTS
				HSYNC     : in  STD_LOGIC;
				VSYNC     : in  STD_LOGIC;
				CLK14     : in  STD_LOGIC;
				CLK28     : in  STD_LOGIC;

				SW_BYPASS : in  STD_LOGIC;  -- activate BYPASS

				-- OUTPUTS
				RE       : out  STD_LOGIC_VECTOR (2 downto 0);  -- Read Enable 0: for field memory
																				-- Read Enable 1: for direct line buffers
																				-- Read Enable 2: for field memory line buffers
				WE : out  STD_LOGIC;                        		-- Write Enable for field memory
				RST_R : out  STD_LOGIC_VECTOR (2 downto 0); 		-- Reset Read 0: Read Counter in field memory
																				-- Reset Read 1: Read Counter in direct line buffers
																				-- Reset Read 2: Read Counter in field memory line buffers
				RST_W : out  STD_LOGIC_VECTOR (2 downto 0); 		-- Reset Write 0: Write Counter in field memory
																				-- Reset Write 1: Write Counter in direct line buffers
																				-- Reset Write 2: Write Counter in field memory line buffers

				HSYNC_O 					: out  STD_LOGIC;		-- VGA HSYNC
				VSYNC_O 					: out  STD_LOGIC;		-- VGA VSYNC
								
				FIELD_0 					: out STD_LOGIC;		-- 14MHZ
				FIELD_1_OKI_RSTR_W 	: out STD_LOGIC;		-- RST_R_S(0) - WRITE RESET FRAME RAM
				FIELD_2_RE_WE 			: out STD_LOGIC; 		-- WE_S - READ WRITE TOGGLE
				N_RSTR_L 				: out STD_LOGIC;		-- READ RESET C+D LINE RAM
				N_RSTW_D 				: out STD_LOGIC;		-- WRITE RESET D LINE RAM
				N_RSTW_C 				: out STD_LOGIC;		-- WRITE RESET C LINE RAM
				N_SCNDBL_N_CSYNC     : in	STD_LOGIC;		-- J481
				
				--JUMPERS
				JP1 						: in STD_LOGIC;		-- JP1
				JP2 						: in STD_LOGIC			-- JP2 - future use, maybe to alter line ram timing for PAL RAM?
			);
 end main;

architecture Behavioral of main is

--buffer to allow change of RGB output from multiple sources, and to allow scanlines feature
signal R0		: STD_LOGIC;
signal R1		: STD_LOGIC;
signal R2		: STD_LOGIC;
signal R3		: STD_LOGIC;
signal R4		: STD_LOGIC;
signal G0		: STD_LOGIC;
signal G1		: STD_LOGIC;
signal G2		: STD_LOGIC;
signal G3		: STD_LOGIC;
signal B0		: STD_LOGIC;
signal B1		: STD_LOGIC;
signal B2		: STD_LOGIC;
signal B3		: STD_LOGIC;

signal SHOWPROGRESSIVVE : STD_LOGIC := '1';

signal BLACKPIXELS		: STD_LOGIC := '0';	--scanline colour for progressive when JP1 set

signal PIXEL_COUNTER		: STD_LOGIC_VECTOR(10 downto 0) := (others =>'0');
signal LINE_COUNTER		: STD_LOGIC_VECTOR(8 downto 0) := (others =>'0');
signal VGA_LINE_COUNTER	: STD_LOGIC_VECTOR(9 downto 0) := (others =>'0');
signal HSYNC_D				: STD_LOGIC := '0';
signal HSYNC_D2			: STD_LOGIC := '0';

signal HSYNC_S				: STD_LOGIC := '0';
signal HSYNC_SD			: STD_LOGIC := '0';
signal VSYNC_S				: STD_LOGIC := '0';

signal HSYNC_1ST_LINE	: STD_LOGIC := '0';
signal HSYNC_2ND_LINE	: STD_LOGIC := '0';
signal FRAME_SYNC			: STD_LOGIC := '0';
signal FRAME_TYPE			: STD_LOGIC := '0';
signal TV_MODE				: STD_LOGIC := '0';

signal RST_W_S				: STD_LOGIC_VECTOR(2 downto 0) := "111";
signal RST_R_S				: STD_LOGIC_VECTOR(2 downto 0) := "111";
signal RE_S					: STD_LOGIC_VECTOR(2 downto 0) := "100";	
signal WE_S					: STD_LOGIC := '1';	
signal BLANK_LINE_S		: STD_LOGIC := '1';	
signal BLANK_S				: STD_LOGIC := '1';	

constant SW_ENABLED     : STD_LOGIC := '0';

--timing values 
--hex notation in vhdl : base#value#

--Amiga pal line is 908 clocks in 3,546895Mhz (C1) = 454 clocks in 7mhz -> 454 clocks in 14Mhz doubles the frequency
constant SCANLINE_WIDTH_PAL_C14 	: integer := 908;--908; 
constant SCANLINE_WIDTH_PAL_VGA 	: integer := SCANLINE_WIDTH_PAL_C14 / 2; 

--Amiga NTSC line is 910 clocks in 3,546895Mhz (C1) = 455 clocks in 7mhz -> 455 clocks in 14Mhz doubles the frequency
constant SCANLINE_WIDTH_NTSC_C14 : integer := 910;
constant SCANLINE_WIDTH_NTSC_VGA : integer := SCANLINE_WIDTH_NTSC_C14 / 2; 

--NTSC toggles between 227/228 NTSC-Clocks on a NTSC-system, BUT not on a PAL-System!

-- TV-Modes
constant NTSC 			: std_logic := '0';
constant PAL  			: std_logic := '1';

-- Frame type
constant EVEN 			: std_logic := '0';
constant ODD  			: std_logic := '1';

-- Frame mode
constant PROGRESSIVE : std_logic := '0';
constant INTERLACE   : std_logic := '1';

constant NTSC_LINES 					: integer := 263; --NTSC has 525 lines in progressive, 262/263 in interlace
constant NTSC_LINES_THREASHOLD 	: integer := NTSC_LINES; 
constant PAL_LINES 					: integer := 313; --PAL has 625 lines in progressive, 312/313 in interlace

constant NTSC_LINES_PROGRESSIVE 	: integer := 525; --NTSC has 525 lines in progressive, 262/263 in interlace
constant PAL_LINES_PROGRESSIVE 	: integer := 625; --PAL has 625 lines in progressive, 312/313 in interlace

-- H-SYNC
constant LINE_RESET_OFFSET 		: integer := -2;--2
constant HSYNC_1ST_TRIGGER_PAL 	: integer := SCANLINE_WIDTH_PAL_VGA  + SCANLINE_WIDTH_PAL_VGA  + LINE_RESET_OFFSET; 
constant HSYNC_2ND_TRIGGER_PAL 	: integer := SCANLINE_WIDTH_PAL_VGA + LINE_RESET_OFFSET; 
constant HSYNC_1ST_TRIGGER_NTSC 	: integer := SCANLINE_WIDTH_NTSC_VGA + SCANLINE_WIDTH_NTSC_VGA + LINE_RESET_OFFSET; 
constant HSYNC_2ND_TRIGGER_NTSC 	: integer := SCANLINE_WIDTH_NTSC_VGA +	LINE_RESET_OFFSET; 
constant HSYNC_PULSE_WIDTH 		: integer := 48; --can be anything between 30 and 65

--blanking
constant HSYNC_FRONTPORCH 							: integer := -22; --substract front porch
constant HSYNC_BACKPORCH 							: integer :=  22; --add back porch
constant BLANK_HSYNC_LINE0_FRONTPORCH_PAL 	: integer := HSYNC_1ST_TRIGGER_PAL + HSYNC_FRONTPORCH;
constant BLANK_HSYNC_LINE1_FRONTPORCH_PAL 	: integer := HSYNC_2ND_TRIGGER_PAL + HSYNC_FRONTPORCH;
constant BLANK_HSYNC_LINE0_BACKPORCH_PAL 		: integer := HSYNC_PULSE_WIDTH + HSYNC_BACKPORCH + LINE_RESET_OFFSET;
constant BLANK_HSYNC_LINE1_BACKPORCH_PAL 		: integer := HSYNC_PULSE_WIDTH + HSYNC_BACKPORCH + HSYNC_2ND_TRIGGER_PAL;
constant BLANK_HSYNC_LINE0_FRONTPORCH_NTSC 	: integer := HSYNC_1ST_TRIGGER_NTSC + HSYNC_FRONTPORCH;
constant BLANK_HSYNC_LINE1_FRONTPORCH_NTSC 	: integer := HSYNC_2ND_TRIGGER_NTSC + HSYNC_FRONTPORCH;
constant BLANK_HSYNC_LINE0_BACKPORCH_NTSC 	: integer := HSYNC_PULSE_WIDTH + HSYNC_BACKPORCH + LINE_RESET_OFFSET;
constant BLANK_HSYNC_LINE1_BACKPORCH_NTSC 	: integer := HSYNC_PULSE_WIDTH + HSYNC_BACKPORCH + HSYNC_2ND_TRIGGER_NTSC;

constant VSYNC_FRONTPORCH 									: integer := -6;
constant VSYNC_BACKPORCH 									: integer := 53;
constant BLANK_VSYNC_BACKPORCH_PROGRESSIVE 			: integer := VSYNC_BACKPORCH;
constant BLANK_VSYNC_BACKPORCH_INTERLACE 				: integer := VSYNC_BACKPORCH + 1;
constant BLANK_VSYNC_FRONTPORCH_NTSC 					: integer := NTSC_LINES_PROGRESSIVE + VSYNC_FRONTPORCH;
constant BLANK_VSYNC_FRONTPORCH_PAL  					: integer := PAL_LINES_PROGRESSIVE	 + VSYNC_FRONTPORCH;

constant FIELD_MEM_WRITE_RESET_PAL 						: integer := 0; --AGA Multifix was 128
constant FIELD_MEM_WRITE_RESET_NTSC 					: integer := 0; --AGA Multifix was 128
constant FIELD_MEM_READ_ENABLE_START_PAL 				: integer := SCANLINE_WIDTH_PAL_VGA;
constant FIELD_MEM_READ_ENABLE_START_NTSC 			: integer := SCANLINE_WIDTH_NTSC_VGA;
constant FIELD_MEM_READ_ENABLE_WIDTH_PAL 				: integer := FIELD_MEM_READ_ENABLE_START_PAL	+ FIELD_MEM_WRITE_RESET_PAL;
constant FIELD_MEM_READ_ENABLE_WIDTH_NTSC 			: integer := FIELD_MEM_READ_ENABLE_START_NTSC + FIELD_MEM_WRITE_RESET_NTSC;
constant FIELD_MEM_READ_RESET_PAL 						: integer := (SCANLINE_WIDTH_PAL_VGA  / 2); 
constant FIELD_MEM_READ_RESET_NTSC 						: integer := (SCANLINE_WIDTH_NTSC_VGA / 2);

constant INTERLACE_LINE1_MEM_WRITE_RESET 		 		: integer := 0; --0 NORMAL --DOES AFFECT PAL RAM
constant INTERLACE_LINE1_MEM_1ST_READ_RESET 	 		: integer := 0; --DOES AFFECT PAL RAM, +64 MOVES IT FURTHER RIGHT
constant INTERLACE_LINE1_MEM_2ND_READ_RESET_PAL  	: integer := SCANLINE_WIDTH_PAL_VGA;
constant INTERLACE_LINE1_MEM_2ND_READ_RESET_NTSC 	: integer := SCANLINE_WIDTH_NTSC_VGA;

constant INTERLACE_LINE2_MEM_READ_RESET_PAL 			: integer := SCANLINE_WIDTH_PAL_VGA;
constant INTERLACE_LINE2_MEM_WRITE_RESET_PAL 		: integer := SCANLINE_WIDTH_PAL_VGA;
constant INTERLACE_LINE2_MEM_READ_RESET_NTSC 		: integer := SCANLINE_WIDTH_NTSC_VGA;
constant INTERLACE_LINE2_MEM_WRITE_RESET_NTSC 		: integer := SCANLINE_WIDTH_NTSC_VGA;

constant INTERLACE_DETECTION 								: integer := HSYNC_1ST_TRIGGER_NTSC / 2;

begin	
	VSYNC_O  <= VSYNC when SW_BYPASS=SW_ENABLED else VSYNC_S;--always scan doubled if bypass switch on
	HSYNC_O  <= HSYNC when SW_BYPASS=SW_ENABLED else HSYNC_S;--always scan doubled if bypass switch on
			
	RE <="101" when SW_BYPASS=SW_ENABLED else RE_S;--always scan doubled if bypass switch on
	WE <='1'  when SW_BYPASS=SW_ENABLED else WE_S;--always scan doubled if bypass switch on
	RST_W <= ('0', HSYNC, '0')  when SW_BYPASS=SW_ENABLED else RST_W_S;--always scan doubled if bypass switch on
	RST_R <= ('0', HSYNC, '0')  when SW_BYPASS=SW_ENABLED else RST_R_S;--always scan doubled if bypass switch on
	
	FIELD_0 <= NOT CLK14;					--CLOCK FOR 74 FLIP FLOP TO CLOCK READS, WRITES AND RESETS ON FRAME RAM
	FIELD_1_OKI_RSTR_W <= RST_W_S(0);   --RST_R_S(0) WORKS FOR NTSC RAM	--RESET FRAME RAM WRITES (READ AND WRITE ALMOST THE SAME WITHIN 1 CLOCK)
	FIELD_2_RE_WE <= WE_S;					--TOGGLE READ/WRITE ON FRAME RAM

	N_RSTR_L <= RST_R_S(1);	--1			--RESET READ ON C+D LINE RAM
	N_RSTW_D <= RST_W_S(2); --2	      --RESET WRITE ON D LINE RAM
	N_RSTW_C <= RST_W_S(1);	--1			--RESET WRITE ON C LINE RAM  (THIS WOULD APPEAR TO BE THE ISSUE???)
	
	--COMBINED LINE RAM BORKED WHEN USING PAL RAM???

	--SET RGB OUTPUT TO BUFFER WHEN SCANLINES OFF, ELSE SCANLINE COLOUR
	ROUT0 <= R0 WHEN BLACKPIXELS = '0' ELSE '0';
	ROUT1 <= R1 WHEN BLACKPIXELS = '0' ELSE '0';
	ROUT2 <= R2 WHEN BLACKPIXELS = '0' ELSE '0';
	ROUT3 <= R3 WHEN BLACKPIXELS = '0' ELSE '0';
	GOUT0 <= G0 WHEN BLACKPIXELS = '0' ELSE '0';
	GOUT1 <= G1 WHEN BLACKPIXELS = '0' ELSE '0';												
	GOUT2 <= G2 WHEN BLACKPIXELS = '0' ELSE '0';
	GOUT3 <= G3 WHEN BLACKPIXELS = '0' ELSE '0';
	BOUT0 <= B0 WHEN BLACKPIXELS = '0' ELSE '0';
	BOUT1 <= B1 WHEN BLACKPIXELS = '0' ELSE '0';												
	BOUT2 <= B2 WHEN BLACKPIXELS = '0' ELSE '0';
	BOUT3 <= B3 WHEN BLACKPIXELS = '0' ELSE '0';
	
	signals: process(CLK14)
	begin
		if(falling_edge(CLK14))then
	
			-- HSYNC: signal sync			
			HSYNC_D2 <= HSYNC_D;
			HSYNC_D  <= HSYNC;
			HSYNC_SD <= HSYNC_S;

			-- VSYNC: signal sync for Edge detection
			VSYNC_S <= VSYNC;		
			
			--  HSYNC counter: catch HSYNC falling edge
			if(HSYNC = '0' and HSYNC_D = '1') then
				PIXEL_COUNTER <= (others =>'0');
			else
				PIXEL_COUNTER <= PIXEL_COUNTER+1;			
			end if;
			
			--PAL/NTSC detection: NTSC has only 525 lines in progressive or 262.5 lines in interlaced
			-- Reset line counters on frame start start
			if(VSYNC ='0' and VSYNC_S ='1') then
				if(LINE_COUNTER > NTSC_LINES_THREASHOLD	) then
					TV_MODE <= PAL;
				else
					TV_MODE <= NTSC;
				end if;
				 -- new Frame -> init counters
				 LINE_COUNTER <= (others =>'0');
				 VGA_LINE_COUNTER <= (others =>'0');
			else --here was a bug: elsif wasn't counting correctly. THANK YOU, Marc!
				-- Amiga (=Input) line counter
				if(HSYNC_D = '0' and HSYNC_D2 = '1') then
					LINE_COUNTER <= LINE_COUNTER+1;
				end if;
				-- VGA (=Output) line counter
				if(HSYNC_S = '0' and HSYNC_SD = '1') then
					VGA_LINE_COUNTER <= VGA_LINE_COUNTER+1;
				end if;
			end if;				

			
			--FRAME_SYNC Signal
			-- catch VSYNC event to detect odd frame and interlace 
			-- this code was fixed by Marc to avoid a strange Amiga-chipsetbug:
			-- If the Amiga is switching from progressive to interlaced mode it might happen
			-- that the half line is on the EVEN frame and not on the ODD frame, where it belongs
			-- This made giana sisters' screen defect!
			-- THANK YOU!
			if( VSYNC = '1' and VSYNC_S = '0' ) then 
				if ( PIXEL_COUNTER >= INTERLACE_DETECTION )then
					if (FRAME_TYPE = EVEN)then
						FRAME_SYNC <= INTERLACE;
					else
						FRAME_SYNC <= PROGRESSIVE;
					end if;
					FRAME_TYPE <= ODD;
				else
				--FRAME_SYNC Signal (even frame)
					if (FRAME_TYPE = EVEN)then
						FRAME_SYNC <= PROGRESSIVE;
					end if;
					FRAME_TYPE <= EVEN;
				end if;
			end if;

			-- field mem control
			-- skip inactive pixel after hsync (beginning of each line)
			-- write enable on counter match
--			if( 	(PIXEL_COUNTER(9 downto 0) < FIELD_MEM_WRITE_RESET_PAL and TV_MODE = PAL) 	or (PIXEL_COUNTER(9 downto 0) >= SCANLINE_WIDTH_PAL_C14  and TV_MODE = PAL ) or
--					(PIXEL_COUNTER(9 downto 0) < FIELD_MEM_WRITE_RESET_NTSC and TV_MODE = NTSC) or (PIXEL_COUNTER(9 downto 0) >= SCANLINE_WIDTH_NTSC_C14 and TV_MODE = NTSC)

			if( 	(PIXEL_COUNTER(9 downto 0) < FIELD_MEM_WRITE_RESET_PAL and TV_MODE = PAL) 	or (PIXEL_COUNTER(9 downto 0) >= SCANLINE_WIDTH_PAL_C14  and TV_MODE = PAL ) or
					(PIXEL_COUNTER(9 downto 0) < FIELD_MEM_WRITE_RESET_NTSC and TV_MODE = NTSC) or (PIXEL_COUNTER(9 downto 0) >= SCANLINE_WIDTH_NTSC_C14 and TV_MODE = NTSC)
				)then
				WE_S <='0'; 			
			else
				WE_S <='1';  -- high active
			end if;
			
			-- read enable on counter match - width must be same as write!
			-- read has to start earliest at middle of expected line
			-- changing the width check below to -128 displays the image OK, except for missing scanlines at the bottom
			-- this suggests it never captured those lines in the line RAM, or field RAM?  Or the line RAM got reset too soon?
			if(	(PIXEL_COUNTER(9 downto 0) >= FIELD_MEM_READ_ENABLE_START_PAL and PIXEL_COUNTER(9 downto 0) < FIELD_MEM_READ_ENABLE_WIDTH_PAL and TV_MODE = PAL) or
				(PIXEL_COUNTER(9 downto 0) >= FIELD_MEM_READ_ENABLE_START_NTSC and PIXEL_COUNTER(9 downto 0) < FIELD_MEM_READ_ENABLE_WIDTH_NTSC and TV_MODE = NTSC)
				)then
				RE_S(0) <='0';
			else
				RE_S(0) <='1';  -- read enable field memory
			end if;			
			
			--read reset: On Frame end reset
			if( (VSYNC = '0' OR (VSYNC = '1' AND VGA_LINE_COUNTER < 42)) and(
					((	PIXEL_COUNTER(9 downto 0) = FIELD_MEM_READ_RESET_PAL or --first line
						PIXEL_COUNTER(9 downto 0) = (SCANLINE_WIDTH_PAL_VGA + FIELD_MEM_READ_RESET_PAL) ) and  TV_MODE = PAL) or--second line
					((PIXEL_COUNTER(9 downto 0) = FIELD_MEM_READ_RESET_NTSC --first line
					or PIXEL_COUNTER(9 downto 0) = (SCANLINE_WIDTH_NTSC_VGA + FIELD_MEM_READ_RESET_NTSC)) and  TV_MODE = NTSC) --second line
					)
				)then
				RST_R_S(0) <='1';  -- read reset field memory line buffer			
			else	
				RST_R_S(0) <='0';
			end if;
			
			-- write reset field memory: Just one clock after read reset
			RST_W_S(0)<= RST_R_S(0);
			
			-- VGA output
			
			-- scanlinebuffer read enable
			if( FRAME_SYNC = INTERLACE and ( 
					( PIXEL_COUNTER(9 downto 0) < SCANLINE_WIDTH_PAL_VGA and TV_MODE = PAL) or
					( PIXEL_COUNTER(9 downto 0) < SCANLINE_WIDTH_NTSC_VGA and TV_MODE = NTSC) 	
					)									
					
				)then
				-- RE for SCANLINE buffer: low active
				RE_S(1) <='1';  
				RE_S(2) <='0';  -- read enable field memory line buffer
 
			else
				-- RE for SCANLINE buffer: low active
				RE_S(1) <='0';  -- read enable direct line buffer
				RE_S(2) <='1';  
			end if;			
		
			-- scanlinebuffer for first (half field) line or 2 lines in progressive mode
			-- read reset
			if ( PIXEL_COUNTER(9 downto 0) = INTERLACE_LINE1_MEM_1ST_READ_RESET or
				 (FRAME_SYNC = PROGRESSIVE and PIXEL_COUNTER(9 downto 0) = INTERLACE_LINE1_MEM_2ND_READ_RESET_PAL  and TV_MODE = PAL) or
				 (FRAME_SYNC = PROGRESSIVE and PIXEL_COUNTER(9 downto 0) = INTERLACE_LINE1_MEM_2ND_READ_RESET_NTSC and TV_MODE = NTSC)
				)then
				RST_R_S(1) <= '0';  -- reset read field memory line buffer
			else
				RST_R_S(1) <= '1';  
			end if;

			-- write reset to direct line buffer
			if( PIXEL_COUNTER(9 downto 0)=INTERLACE_LINE1_MEM_WRITE_RESET)then
				RST_W_S(1) <= '0';  -- reset write field memory line buffer
			else
				RST_W_S(1) <= '1';
			end if;

			-- scanlinebuffer for second (half field) line or disabled for progressive mode
			-- read reset
			if( ((PIXEL_COUNTER(9 downto 0) = INTERLACE_LINE2_MEM_READ_RESET_PAL and TV_MODE = PAL) or
				 (PIXEL_COUNTER(9 downto 0) = INTERLACE_LINE2_MEM_READ_RESET_NTSC and TV_MODE = NTSC))
				 and FRAME_SYNC = INTERLACE and VSYNC = '0' --added vsync = 0
				)then
				RST_R_S(2) <= '0';
			else
				RST_R_S(2) <= '1';  -- reset read field memory line buffer
			end if;
			
			--write reset 
			if( (PIXEL_COUNTER(9 downto 0) = INTERLACE_LINE2_MEM_WRITE_RESET_PAL  and TV_MODE = PAL) or
				(PIXEL_COUNTER(9 downto 0) = INTERLACE_LINE2_MEM_WRITE_RESET_NTSC and TV_MODE = NTSC)
				)then
				RST_W_S(2) <= '0';
			else
				RST_W_S(2) <= '1';
			end if;
			
			--HSYNC doubling

			if ( TV_MODE = PAL ) then
				--HSYNC_1ST_LINE 
				if( (PIXEL_COUNTER(9 downto 0)>= HSYNC_PULSE_WIDTH+LINE_RESET_OFFSET and PIXEL_COUNTER(9 downto 0) < HSYNC_1ST_TRIGGER_PAL )
					)then
					HSYNC_1ST_LINE <= '0';
				else
					HSYNC_1ST_LINE <= '1';
				end if;
			
				--HSYNC_2ND_LINE 
				if( (PIXEL_COUNTER(9 downto 0) >= HSYNC_2ND_TRIGGER_PAL  and PIXEL_COUNTER(9 downto 0)< HSYNC_2ND_TRIGGER_PAL  + HSYNC_PULSE_WIDTH) --trigger
					)then
					HSYNC_2ND_LINE <= '1';
				else
					HSYNC_2ND_LINE <= '0';
				end if;
			else -- NTSC
				--HSYNC_1ST_LINE 
				if((PIXEL_COUNTER(9 downto 0)>= HSYNC_PULSE_WIDTH + LINE_RESET_OFFSET and PIXEL_COUNTER(9 downto 0) < HSYNC_1ST_TRIGGER_NTSC)
					)then
					HSYNC_1ST_LINE <= '0';
				else
					HSYNC_1ST_LINE <= '1';
				end if;
				
				--HSYNC_2ND_LINE 
				if( (PIXEL_COUNTER(9 downto 0) >= HSYNC_2ND_TRIGGER_NTSC and PIXEL_COUNTER(9 downto 0)< HSYNC_2ND_TRIGGER_NTSC + HSYNC_PULSE_WIDTH) 
					)then
					HSYNC_2ND_LINE <= '1';
				else
					HSYNC_2ND_LINE <= '0';
				end if;
			end if;

			--HSYNC-Signal
			HSYNC_S <= not ( HSYNC_1ST_LINE or HSYNC_2ND_LINE );
			
			--blank vsync
			if( ( VGA_LINE_COUNTER(9 downto 0) <= BLANK_VSYNC_BACKPORCH_INTERLACE and FRAME_SYNC = INTERLACE)     or
				( VGA_LINE_COUNTER(9 downto 0) <= BLANK_VSYNC_BACKPORCH_PROGRESSIVE and FRAME_SYNC = PROGRESSIVE) or
				((VGA_LINE_COUNTER(9 downto 0) >= BLANK_VSYNC_FRONTPORCH_PAL  ) and TV_MODE = PAL ) or
				((VGA_LINE_COUNTER(9 downto 0) >= BLANK_VSYNC_FRONTPORCH_NTSC ) and TV_MODE = NTSC )
				 )then
				BLANK_LINE_S <='0';
			else
				BLANK_LINE_S <='1';
			end if;
			
			--blank hsync
			if( ((PIXEL_COUNTER(9 downto 0) >= BLANK_HSYNC_LINE1_FRONTPORCH_PAL  and PIXEL_COUNTER(9 downto 0)< BLANK_HSYNC_LINE1_BACKPORCH_PAL ) and TV_MODE = PAL ) or
				((PIXEL_COUNTER(9 downto 0) >= BLANK_HSYNC_LINE1_FRONTPORCH_NTSC and PIXEL_COUNTER(9 downto 0)< BLANK_HSYNC_LINE1_BACKPORCH_NTSC) and TV_MODE = NTSC) or
				((PIXEL_COUNTER(9 downto 0) >= BLANK_HSYNC_LINE0_FRONTPORCH_PAL  or  PIXEL_COUNTER(9 downto 0)< BLANK_HSYNC_LINE0_BACKPORCH_PAL ) and TV_MODE = PAL ) or
				((PIXEL_COUNTER(9 downto 0) >= BLANK_HSYNC_LINE0_FRONTPORCH_NTSC or  PIXEL_COUNTER(9 downto 0)< BLANK_HSYNC_LINE0_BACKPORCH_NTSC) and TV_MODE = NTSC) 
				 )then
				BLANK_S <= '0';
			else
				BLANK_S <= '1';
			end if;
					
	end if;		
		
end process;

process(CLK28)
	begin
		if(falling_edge(CLK28))then
			--DIRECT RGB, NOT SCANDOUBLED (BYPASS SWITCH ON)
			if (SW_BYPASS = SW_ENABLED) then
					R0 <= RIN0;
					R1 <= RIN1;
					R2 <= RIN2;
					R3 <= RIN3;
					G0 <= GIN0;
					G1 <= GIN1;												
					G2 <= GIN2;
					G3 <= GIN3;
					B0 <= BIN0;
					B1 <= BIN1;												
					B2 <= BIN2;
					B3 <= BIN3;	
			else
				--SCANDOUBLED	
				--SETTING THIS TO RE_S(2) FIXES THIS FRAME ALIGNMENT WITH PAL RAM???
				if (RE_S(1) = '0') then --READ COMBINED LINE BUFFER --WAS (1)
						R0 <= RC0;
						R1 <= RC1;
						R2 <= RC2;
						R3 <= RC3;
						G0 <= GC0;
						G1 <= GC1;												
						G2 <= GC2;
						G3 <= GC3;
						B0 <= BC0;
						B1 <= BC1;												
						B2 <= BC2;
						B3 <= BC3;
				end if;
				--technically it might be possible for these to overlap?
				if (RE_S(2) = '0') then --RE LOW DELAYED LINE BUFFERS
					R0 <= RD0;
					R1 <= RD1;
					R2 <= RD2;
					R3 <= RD3;
					G0 <= GD0;
					G1 <= GD1;												
					G2 <= GD2;
					G3 <= GD3;
					B0 <= BD0;
					B1 <= BD1;												
					B2 <= BD2;
					B3 <= BD3;	
				end if;
			end if;
			
			--SCANLINE GENERATOR
			--SEEMS TO WORK OK FOR ONLY PROGRESSIVE - NO POINT APPLYING TO INTERLACED...
			--if (SW_BYPASS = SW_ENABLED) then
				if ((JP1 = '0' AND N_SCNDBL_N_CSYNC = '0') AND (VGA_LINE_COUNTER(0) = '1') AND (FRAME_SYNC = PROGRESSIVE)) OR ((BLANK_LINE_S = '0') OR (BLANK_S = '0')) then
					BLACKPIXELS <= SW_BYPASS;
				else
					BLACKPIXELS <= '0';
				end if;	
			--end if;
			
		end if;

end process;

end Behavioral;

