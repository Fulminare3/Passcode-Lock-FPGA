library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity PmodKYPD_Nexsy4 is
    Port ( clk : in STD_LOGIC;
           JA : inout STD_LOGIC_VECTOR (7 downto 0);    -- PmodKYPD connected to Pmod JA
           an : out STD_LOGIC_VECTOR (7 downto 0);      -- Controls which position of the 8 seven segment displays to display
           seg: out STD_LOGIC_VECTOR (6 downto 0);     -- digit to display on seven segment display
           LED: out STD_LOGIC_VECTOR (15 downto 0);
           BTNC : in STD_LOGIC);
end PmodKYPD_Nexsy4;

architecture Behavioral of PmodKYPD_Nexsy4 is
component Decoder is
	Port ( clk : in  STD_LOGIC;
           Row : in  STD_LOGIC_VECTOR (3 downto 0);
		   Col : out  STD_LOGIC_VECTOR (3 downto 0);
           DecodeOut : out  STD_LOGIC_VECTOR (3 downto 0));
	end component;

component DisplayController is
	Port ( DispVal : in  STD_LOGIC_VECTOR (3 downto 0);
           anode:    out std_logic_vector(7 downto 0);
           segOut :  out  STD_LOGIC_VECTOR (6 downto 0));
	end component;
	
component PasscodeLock is
	Port ( clk : in STD_LOGIC;
	       DecodedInput : in  STD_LOGIC_VECTOR (3 downto 0);
		   StoreMode : in BOOLEAN;
		   ResetButton : in STD_LOGIC;
		   LedDisplay: out STD_LOGIC_VECTOR (15 downto 0));
	end component;

signal Decode: STD_LOGIC_VECTOR (3 downto 0);
signal Flag_Store : BOOLEAN := True;

begin
    C0: Decoder port map (clk=>clk, Row =>JA(7 downto 4), Col=>JA(3 downto 0), DecodeOut=> Decode);
	C1: DisplayController port map (DispVal=>Decode, anode=>an, segOut=>seg );
	C2: PassCodeLock port map (clk=>clk,DecodedInput=>Decode, StoreMode=>Flag_Store, LedDisplay=>LED, ResetButton=>BTNC);
	
end Behavioral;
