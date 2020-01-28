-- Authors: Connor Van Meter & Alex Salois
-- EELE 468

library IEEE;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;

entity add_1 is
  port (input_vector  : in  std_logic_vector (7 downto 0);
	output_vector : out std_logic_vector (7 downto 0));
end entity;

architecture add_1_arch of add_1 is

  signal input : unsigned(7 downto 0);
  signal output : unsigned(7 downto 0);

  begin

    input  <= unsigned(input_vector);
    output <= input + "00000001";
    output_vector <= std_logic_vector(output);

end architecture;