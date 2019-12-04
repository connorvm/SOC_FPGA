-- This file will be the top level in our design

-- Authors: Connor Van Meter, Alex Salois


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_unsigned.all;

LIBRARY altera;
USE altera.altera_primitives_components.all;


entity qsys_alu is
    port(
			clk            : in  std_logic;                         -- system clock
			reset          : in  std_logic;                         -- system reset
			result_h			: out std_logic_vector(31 downto 0); 	  -- results
			result_l			: out std_logic_vector(31 downto 0); 	  -- results
			status			: out std_logic_vector(2 downto 0); 	  -- status flags
			a					: in  std_logic_vector(31 downto 0); 	  -- input regs
			b					: in  std_logic_vector(31 downto 0); 	  -- 
			c					: in  std_logic_vector(31 downto 0); 	  -- 
			opcode			: in  std_logic_vector(2 downto 0) 	  -- opcode
    );
end entity qsys_alu;


architecture qsys_alu_arch of qsys_alu is 


    begin



end architecture qsys_alu_arch;