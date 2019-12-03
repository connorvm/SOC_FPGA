--This file will be handling the status register logic--

-- Authors: Connor Van Meter, Alex Salois


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_unsigned.all;

LIBRARY altera;
USE altera.altera_primitives_components.all;


entity status_reg is
    port(
        clk            	: in  std_logic;                         -- system clock
        reset          	: in  std_logic;                         -- system reset
 		  result_h			: in std_logic_vector(31 downto 0); 	  -- results
		  result_l			: in std_logic_vector(31 downto 0) 	  -- results
    );
end entity status_reg;


architecture status_arch of status_reg is 


 --signal result : std_logic_vector(7 downto 0);
 signal z_flag : std_logic;      --signal for the Zero Flag, indicates if result is zero
 signal n_flag : std_logic;      --signal for the Negative Flag, indicates if result is negative
 signal f_flag : std_logic;      --signal for the F flag, indicates if both Registers 3 and 4 are used


    begin
	 process(result_l, result_h)
		begin
		-- z_flag will be set if the result of an operation is ZERO --   
		if result_l = x"00000000" then
			z_flag <= '1';
		end if;

     -- n_flag will be set if the result of an operation is NEGATIVE --
		if result_l(31) = '1' then   --If the first bit of the result is a '1', then it is negative
			n_flag <= '1';
		end if;

     -- f_flag will be set if the result uses both registers --
	  
	  end process;





end architecture status_arch;

