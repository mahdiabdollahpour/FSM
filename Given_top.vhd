----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:40:27 12/28/2017 
-- Design Name: 
-- Module Name:    Given_top - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_signed.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Given_top is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           x_c : out  STD_LOGIC_VECTOR (31 downto 0);
           y_c : out  STD_LOGIC_VECTOR (31 downto 0);
           left : in  STD_LOGIC_VECTOR (1 downto 0);
           right : in  STD_LOGIC_VECTOR (1 downto 0);
           clk_out : out  STD_LOGIC;
           rgb : out  STD_LOGIC_VECTOR (9 downto 0);
           vsync : out  STD_LOGIC;
           hsync : out  STD_LOGIC);
end Given_top;

architecture Behavioral of Given_top is



component location is
  Port (
   reset : in std_logic;
   clkin : in std_logic;
   clkout : out std_logic;
   left: in std_logic_vector (1 downto 0);
   right: in std_logic_vector (1 downto 0);
   current_location_x: out std_logic_vector (31 downto 0);
   current_location_y: out std_logic_vector (31 downto 0)
  );
end component location;
component top_pong 
port
(
	clock 	: in std_logic ;
	reset 	: in std_logic ;
	hsync		: out std_logic ;
	vsync		: out std_logic ;
	rgb		: out std_logic_vector(9 downto 0 ); 
	inp_x		: in 	std_logic_vector (31 downto 0);
	inp_y		: in 	std_logic_vector (31 downto 0) 
);
end component top_pong;
--signal clk_d2 : std_logic;
signal current_location_x:  std_logic_vector (31 downto 0);
signal current_location_y:  std_logic_vector (31 downto 0);
--signal x_c :   STD_LOGIC_VECTOR (31 downto 0);
--signal y_c :   STD_LOGIC_VECTOR (31 downto 0);
--signal left :   STD_LOGIC_VECTOR (1 downto 0);
--signal right :   STD_LOGIC_VECTOR (1 downto 0);
--signal clk_out :   STD_LOGIC;

begin
--clk_out <= clk_d2;
x_c <= current_location_x;
y_c <= current_location_y;
U1_location: location port map (reset, clk, clk_out, left, right, current_location_x, current_location_y);
U2_top_pong: top_pong port map (clk, reset, hsync, vsync, rgb, current_location_x, current_location_y);
end Behavioral;

