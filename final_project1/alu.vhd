-- This file will be the top level in our design

-- Authors: Connor Van Meter, Alex Salois


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_unsigned.all;

LIBRARY altera;
USE altera.altera_primitives_components.all;


entity alu is
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
end entity alu;


architecture alu_arch of alu is 

	component operations is
    port(
			clk            : in  std_logic;                         -- system clock
			reset          : in  std_logic;                         -- system reset
			result_h			: out std_logic_vector(31 downto 0); 	  -- results
			result_l			: out std_logic_vector(31 downto 0); 	  -- results
			a					: in  std_logic_vector(31 downto 0); 	  -- input regs
			b					: in  std_logic_vector(31 downto 0); 	  -- 
			c					: in  std_logic_vector(31 downto 0); 	  -- 
			opcode			: in  std_logic_vector(2 downto 0) 	  -- opcode
        );
	end component operations;
	
	component status_reg is
    port(
			clk          : in  std_logic;                        -- system clock
			reset        : in  std_logic;                        -- system reset
			result_h	    : in  std_logic_vector(31 downto 0); 	  -- result in high register
			result_l		 : in  std_logic_vector(31 downto 0); 	  -- result in low register
			status		 : out std_logic_vector(2 downto 0)
    );
	end component status_reg;
	
	-- intermediate signals
	signal result_low  	:	std_logic_vector(31 downto 0);
	signal result_high	:  std_logic_vector(31 downto 0);
	signal swap_a			:  std_logic_vector(31 downto 0);
	signal swap_b			:  std_logic_vector(31 downto 0);
	
	begin
	
		Uops: operations
		port map(
			clk			=> clk,                     
			reset      	=> reset,
			result_h		=> result_high,
			result_l		=> result_low,
			a				=> swap_a,
			b				=> swap_b,
			c				=> c,
			opcode		=> opcode
        );
		  
		 Ustatus: status_reg
		 port map(
			clk			=> clk,                      
			reset      	=> reset,
			result_h		=> result_high,
			result_l		=> result_low,
			status		=> status
       );
		 
		 process(clk) -- swap when needed
		 begin
			if rising_edge(clk) then
				if opcode = "110" then
					swap_a <= b;
					swap_b <= a;
				else
					swap_a <= a;
					swap_b <= b;
				end if;
			end if;
		end process; 



end architecture alu_arch;
    
