-- This file will 

-- Authors: Connor Van Meter, Alex Salois


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_unsigned.all;

LIBRARY altera;
USE altera.altera_primitives_components.all;

--need to know the registers(a, b, high, low) and switches
--output just LEDs?

entity qsys_alu is
    port(
			clk            : in  std_logic;                         -- system clock
			reset          : in  std_logic;                         -- system reset
			result_h			: in std_logic_vector(31 downto 0); 	  -- results
			result_l			: in std_logic_vector(31 downto 0); 	  -- results
			a					: in  std_logic_vector(31 downto 0); 	  -- input regs
            b					: in  std_logic_vector(31 downto 0); 	  -- 
            SW              : in std_logic_vector(3 downto 0);           -- Switches
            LED             : out std_logic_vector(7 downto 0)          --LEDs
    );
end entity qsys_alu;


architecture qsys_alu_arch of qsys_alu is 


    signal show_reg  : std_logic_vector(1 downto 0);
    signal show_byte : std_logic_vector(7 downto 0);
    signal a_reg     : std_logic_vector(1 downto 0);
    signal b_reg     : std_logic_vector(1 downto 0);
    signal h_reg     : std_logic_vector(1 downto 0);
    signal l_reg     : std_logic_vector(1 downto 0);

    begin

        --Switches[3-2] controls which register is selected
        --Switches[1-0] controls which byte in register is shown
        process (clk, reset, SW)
        begin

            case SW(3 downto 2) is
                when "00" => show_reg <= a_reg; --when 0, display Register a
                when "01" => show_reg <= b_reg; --when 1, display Register b
                when "10" => show_reg <= l_reg; --when 2, display Low Register
                when "11" => show_reg <= h_reg; --when 3, display High Register
                when others => show_reg <= "00";
            end case;

            case SW(1 downto 0) is
                when "00" => show_byte <= 
                
                    
            
                when others =>
            end case ;
        end process;



end architecture qsys_alu_arch;