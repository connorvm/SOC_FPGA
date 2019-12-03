-- Author: Connor Van Meter
-- Lab Partner: Alex Salois


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_unsigned.all;

LIBRARY altera;
USE altera.altera_primitives_components.all;


entity PB_condition is
    port(
        clk     : in  std_logic;                         -- system clock
        reset   : in  std_logic;                         -- system reset
        PB      : in  std_logic;                          -- Pushbutton to change state
		  PB_sync : out std_logic
		  );
end entity PB_condition;


architecture PB_arch of PB_condition is

	signal PB1		: std_logic;


  begin
	
	process (clk)
	 variable   cnt : integer;
		begin
		
		if (rising_edge(clk)) then
			PB_sync <= PB1;
			PB1 <= PB;
				
			if PB = '1' and cnt = 0 then
				PB_sync <= '1';
				cnt := 1;
				
			elsif cnt > 0 and cnt <= 5000000 then
				cnt := cnt + 1;
				PB_sync <= '0';
					
			else
				cnt := 0;
				PB_sync <= '0';				
			end if;
		end if;
	end process;
	
	
	
	
end architecture PB_arch;