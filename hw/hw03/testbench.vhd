-- Authors: Connor Van Meter & Alex Salois
-- EELE 468

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use STD.textio.all;
use IEEE.std_logic_textio.all;

entity testbench is
  PORT ( count : BUFFER bit_vector(8 downto 1));
end; 

component add_1 is
  port (  Input  : in  std_logic_vector (7 downto 0);
	        Output : out std_logic_vector (7 downto 0));
end component;

signal clk   : bit := '0';
signal input : std_logic_vector (7 downto 0) := x'00' 

dut : add_1
   port map(
      coun => count,
      clk => clk,
      );

clock : PROCESS
   begin
   wait for 10 ns; clk  <= not clk;
end PROCESS clock;

architecture add_1_arch of add_1 is

  begin



end architecture;