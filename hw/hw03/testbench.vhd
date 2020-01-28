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

architecture testbench_arch of testbench is
component add_1 is
  port (input_vector  : in  std_logic_vector (7 downto 0);
	output_vector : out std_logic_vector (7 downto 0));
end component;

signal input_sig  : std_logic_vector(7 downto 0) := "00000000";
signal output_sig : std_logic_vector(7 downto 0) := "00000000";

  begin

dut : add_1
   port map(
      input_vector  => input_sig,
      output_vector => output_sig);


end architecture;