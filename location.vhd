----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/14/2017 04:23:58 PM
-- Design Name: 
-- Module Name: location - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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
use IEEE.std_logic_arith.all;

entity location is
  Port (
   reset : in std_logic;
   clkin : in std_logic;
   clkout : out std_logic;
   left: in std_logic_vector (1 downto 0);
   right: in std_logic_vector (1 downto 0);
   current_location_x: out std_logic_vector (31 downto 0);
   current_location_y: out std_logic_vector (31 downto 0)
  );
end location;


architecture Behavioral of location is
component clk_div 
       port (
           cout   :out std_logic;  -- Output clock
           enable :in  std_logic;  -- Enable counting
           clk    :in  std_logic;  -- Input clock
           reset  :in  std_logic   -- Input reset
       );
       end component;
signal clk :std_logic;
signal x_ref, y_ref, x_ref_r, y_ref_r, x_c, y_c, counter : std_logic_vector (31 downto 0);
signal teta_p  : integer range 0 to 2**12-1;
constant diameter : integer  := 50;
constant speed : integer := 5;
signal degree : std_logic_vector( 11 downto 0);
signal sine, cosine : std_logic_vector(31 downto 0);
shared variable tmp1, tmp2, tmp3, tmp4: std_logic_vector (63 downto 0);
begin
u1: clk_div port map (clk, '1', clkin, reset);
DUT: entity work.sine_cosine port map(clkin, reset, degree, sine, cosine);
	process(clk,reset)
	begin
	if(reset = '1')then
		--teta_c <= 180;
		teta_p <= 0;
	elsif(rising_edge(clk)) then
		if(left = "01" and right = "01") then -- move forward
		    if (teta_p > 270)then
		      degree <=  conv_std_logic_vector(teta_p - 270, 12);
		    else
                degree <=  conv_std_logic_vector(teta_p +90, 12);
            end if;
		elsif(left = "10" and right = "10") then -- move backward
			 if (teta_p > 270)then
                      degree <=  conv_std_logic_vector(teta_p - 270, 12);
                    else
                        degree <=  conv_std_logic_vector(teta_p +90, 12);
                    end if;
		elsif(left = "00" and right = "01") then -- turn left
                
			 if(teta_p > 359) then
				  teta_p <= teta_p - 345;
				  degree <=  conv_std_logic_vector(teta_p - 345, 12);
			 else
				  teta_p <= teta_p + 15;
				  degree <=  conv_std_logic_vector(teta_p + 15, 12); 
			 end if;
		 elsif(left = "01" and right = "00") then -- turn right
			 if(teta_p < 15 ) then
				  teta_p <= teta_p + 345;
				  degree <=  conv_std_logic_vector(teta_p + 165, 12);
			 elsif(teta_p < 181) then
				  teta_p <= teta_p - 15;
                  degree <=  conv_std_logic_vector(teta_p + 165, 12);
			 elsif(teta_p < 195 ) then
                   teta_p <= teta_p - 15;
                   degree <=  conv_std_logic_vector(teta_p + 165, 12);
              else 
                   teta_p <= teta_p - 15;
                   degree <=  conv_std_logic_vector(teta_p - 195, 12);
              end if;
			 --degree <=  conv_std_logic_vector(teta_p, 12);
		 end if;
		 end if;
	end process;
    process (clk, reset)
--    variable tmp1, tmp2, tmp3, tmp4: std_logic_vector (63 downto 0);
    begin
        if (reset= '1') then
            x_ref <= conv_std_logic_vector ((4*10**8)-(integer(diameter)),32);
            y_ref <= conv_std_logic_vector ((4*10**8),32);
            x_ref_r <= conv_std_logic_vector ((4*10**8) + (integer(diameter)),32);
            y_ref_r <= conv_std_logic_vector (4*10**8,32);
            x_c <= conv_std_logic_vector (4*10**8,32);
            y_c <= conv_std_logic_vector (4*10**8,32);
				counter <= (others => '0');
--            teta_c <= 180;
--            teta_p <= 0;
        elsif(falling_edge (clk)) then
				tmp1 := (conv_std_logic_vector(speed, 32) * cosine(31 downto 0));
            tmp2 := (conv_std_logic_vector(speed, 32) * sine(31 downto 0));
				tmp3 := (conv_std_logic_vector(diameter, 32) * cosine(31 downto 0));
            tmp4 := (conv_std_logic_vector(diameter, 32) * sine(31 downto 0));
				counter <= counter+1;
				if(left = "01" and right = "01") then -- move forward
                --degree <=  conv_std_logic_vector(teta_p +90, 12);
               -- tmp1 := (conv_std_logic_vector(speed, 32) * cosine(31 downto 0));
             --   tmp2 := (conv_std_logic_vector(speed, 32) * sine(31 downto 0));
                x_c <= x_c + tmp1 (43 downto 12);
                y_c <= y_c + tmp2 (43 downto 12);
                x_ref <= x_ref + tmp1 (43 downto 12);
                y_ref <= y_ref + tmp2 (43 downto 12);
                x_ref_r <= x_ref_r + tmp1 (43 downto 12);
                y_ref_r <= y_ref_r + tmp2 (43 downto 12);
            --end if;
            elsif(left = "10" and right = "10") then -- move backward
                --degree <=  conv_std_logic_vector(teta_p +90, 12);
          --      tmp1 := (conv_std_logic_vector(speed, 32) * cosine(31 downto 0));
          --      tmp2 := (conv_std_logic_vector(speed, 32) * sine(31 downto 0));
                x_c <= x_c - tmp1 (43 downto 12);
                y_c <= y_c - tmp2 (43 downto 12);
                x_ref <= x_ref - tmp1 (43 downto 12);
                y_ref <= y_ref - tmp2 (43 downto 12);
                x_ref_r <= x_ref_r - tmp1 (43 downto 12);
                y_ref_r <= y_ref_r - tmp2 (43 downto 12);
                --report "tresd" ;    
            elsif(left = "00" and right = "01") then -- turn left
                
              --  if(teta_p >359) then
              --      teta_p <= teta_p -345;
              --  else
              --      teta_p <= teta_p +15; 
              --  end if;
              --  degree <=  conv_std_logic_vector(teta_p, 12);
              --  tmp3 := (conv_std_logic_vector(diameter, 32) * cosine(31 downto 0));
              --  tmp4 := (conv_std_logic_vector(diameter, 32) * sine(31 downto 0));
                x_c <= x_ref + tmp3(43 downto  12);   
                y_c <= y_ref + tmp4(43 downto  12);
                x_ref_r <= x_ref + tmp3(42 downto  11);   
                y_ref_r <= y_ref + tmp4(42 downto  11);    
              --  report tmp3;          
            elsif(left = "01" and right = "00") then -- turn right
--                if(teta_c < 15 ) then
--                    teta_c <= teta_c +345;
--                else 
--                    teta_c <= teta_c -15;
--                end if; 
--                degree <=  conv_std_logic_vector(teta_c, 12);
             --   tmp3 := (conv_std_logic_vector(diameter, 32) * cosine(31 downto 0));
              --  tmp4 := (conv_std_logic_vector(diameter, 32) * sine(31 downto 0));
                x_c <= x_ref_r + tmp3(43 downto  12);   
                y_c <= y_ref_r + tmp4(43 downto  12);
                x_ref <= x_ref_r + tmp3(42 downto  11);   
                y_ref <= y_ref_r + tmp4(42 downto  11);  
					
            end if;   
          --  x_p <= x_c;  
          --  y_p <= y_c;       
            
        end if;

    end process;
current_location_x <= x_c;
current_location_y <= y_c;
clkout <= clk;
end Behavioral;
