-------------------------------------------------------
-- Design Name : clk_div
-- File Name   : clk_div.vhd
-- Function    : Divide by two counter
-- Coder       : Deepak Kumar Tala (Verilog)
-- Translator  : Alexander H Pham (VHDL)
-------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

entity clk_div is
    port (
        cout   :out std_logic;  -- Output clock
        enable :in  std_logic;  -- Enable counting
        clk    :in  std_logic;  -- Input clock
        reset  :in  std_logic   -- Input reset
    );
end entity;

architecture rtl of clk_div is
    signal clk_div :std_logic;
begin
    process (clk, reset) begin
        if (reset = '1') then
            clk_div <= '0';
        elsif (rising_edge(clk)) then
            if (enable = '1') then
                clk_div <= not clk_div;
            end if;
        end if;
    end process;
    cout <= clk_div;
end architecture;