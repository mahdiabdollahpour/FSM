
----------------------------------------------------------------------------------
-- text v2

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

			

entity pong_text is
port 
(
	clock			: in std_logic ;
	reset 		: in std_logic ;
	pixel_x		: in std_logic_vector( 9 downto 0 );
	pixel_y		: in std_logic_vector( 9 downto 0 );
	--dig0			: in std_logic_vector( 3 downto 0 );
	--dig1			: in std_logic_vector( 3 downto 0 );
	--winner 		: in std_logic ;
	--win_on  		: in std_logic ;
	
	text_rgb		: out std_logic_vector( 9 downto 0 );
	text_on 		: out std_logic; 
	
	inp_x			: in 	std_logic_vector( 31 downto 0 );
	inp_y			: in 	std_logic_vector( 31 downto 0 )
);

end pong_text;

architecture Behavioral of pong_text is
constant x_min : integer:=300;
constant y_min : integer:=50;
constant x_max : integer:=1000;
constant y_max : integer:=600;
constant line_width : integer:=5;
constant u_x_target_1 : integer:=0; -- unscaled points
constant u_y_target_1 : integer:=2;
constant u_x_target_2 : integer:=8;
constant u_y_target_2 : integer:=7;
constant x_target_1 : integer:=x_min+((u_x_target_1*(x_max-x_min))/(8)); --scaled to VGA size
constant y_target_1 : integer:=y_min+((u_y_target_1*(y_max-y_min))/(8));
constant x_target_2 : integer:=x_min+((u_x_target_2*(x_max-x_min))/(8));
constant y_target_2 : integer:=y_min+((u_y_target_2*(y_max-y_min))/(8));
constant point_size : integer:=10;

constant x_target_4 : integer:=x_min+(((((8*10**8)/(2**20))*(x_max - x_min))/(512))*5/8);
constant y_target_4 : integer:=y_min+(((((7*10**8)/(2**20))*(y_max-y_min))/(512))*5/8);
constant x_target_5 : integer:= x_min+0;
constant y_target_5 : integer:=y_min+((((2*10**8)/(2**20)*(y_max-y_min))/(512))*5/8);

signal x_target_3 : integer;--:=x_min+((3)*(x_max-x_min))/(8);
signal y_target_3 : integer;--:=y_min+(2*(y_max-y_min))/(8);
signal u_x_target_3 : integer;--:=x_min+((3)*(x_max-x_min))/(8);
signal u_y_target_3 : integer;--

signal pix_x , pix_y : integer ;
begin
u_x_target_3 <= to_integer (signed(inp_x))/(2**20);
u_y_target_3 <= to_integer(signed(inp_y))/(2**20);
x_target_3 <= x_min + (((u_x_target_3*(x_max-x_min))/(512))*5/8);
y_target_3 <= y_min + (((u_y_target_3*(y_max-y_min))/(512))*5/8);
pix_x <= to_integer(unsigned(pixel_x));
pix_y <= to_integer(unsigned(pixel_y));

process (clock)
begin
	if rising_edge(clock) then
		if((((inp_x < ((8*10**8)+10)) and (inp_x > ((8*10**8)-10)) and (inp_y <(7*10**8)+10) and (inp_y > (7*10**8)-10))or
			((inp_x < 10 and inp_x > -10) and (inp_y < (2*10**8)+10) and (inp_y > (2*10**8)-10))) and 
			((pix_x > 300 and pix_x < 1000) and (pix_y > 50  and pix_y < 600)))
			then
				text_on <= '1';			
		--if(pix_x > 230 and pix_y > 50 and pix_x < 240 and pix_y < 60) then
		elsif((pix_x > 295 and pix_x < 300) or (pix_y > 45  and pix_y < 50) or 
		(pix_x > 1005 and pix_x < 1010) or (pix_y > 605  and pix_y < 610) or
		((pix_x > x_target_4 and pix_x < x_target_4+10) and (pix_y > y_target_4  and pix_y < y_target_4+10))or
		((pix_x > x_target_5 and pix_x < x_target_5+10) and (pix_y > y_target_5  and pix_y < y_target_5+10))or
		((pix_x > x_target_3 and pix_x < x_target_3+10) and (pix_y > y_target_3  and pix_y < y_target_3+10))
		) then
		--if(pix_x > 1000 and pix_y > 600 and pix_x < 1010 and pix_y < 610) then
			text_on <= '1';
		else
			text_on <= '0';
		end if;
	end if;
end process;
	 
	 text_rgb <= "1111111111" ;  -- background, yellow
--text_on<='1';
end Behavioral;

