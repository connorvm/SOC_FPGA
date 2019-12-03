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
        clk            	: in  std_logic;                          -- system clock
        reset          	: in  std_logic;                          -- system reset
 		result_h	    : in std_logic_vector(31 downto 0); 	  -- result in high register
		result_l		: in std_logic_vector(31 downto 0) 	      -- result in low register
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
        else
            z_flag <= '0';
		end if;

        -- n_flag will be set if the result of an operation is NEGATIVE --
        if f_flag = '1' then    -- We know the high register has something in it
            if result_h(31) = '1' then
                n_flag <= '1';
            else
                n_flag <= '0';
            end if;

        elsif f_flag = '0' then     --Only the low register is used, so only need to check low register
            if result_l(31) = '1' then   --If the first bit of the result_l is a '1', then it is negative
			    n_flag <= '1';
            else
                n_flag <= '0';
            end if;
        end if;

        -- f_flag will be set if the result uses both registers --
        if result_h = x"00000000" then  --If the register is full of 0's(empty), then it is not used
            f_flag <= '0';
        else
            f_flag <= '1';      --If the high register has something in it, then the flag is set
        end if; 
        
	  
	  end process;





end architecture status_arch;

