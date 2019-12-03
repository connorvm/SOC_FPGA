-- This file will handle all of the opcodes and its operations

-- Authors: Connor Van Meter, Alex Salois


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_unsigned.all;
    
LIBRARY altera;
USE altera.altera_primitives_components.all;
    
    
entity operations is
    port(
			clk            : in  std_logic;                         -- system clock
			reset          : in  std_logic;                         -- system reset
			result_h			: out std_logic_vector(31 downto 0); 	  -- results
			result_l			: out std_logic_vector(31 downto 0); 	  -- results
			a					: in  std_logic_vector(31 downto 0); 	  -- operand A
			b					: in  std_logic_vector(31 downto 0); 	  -- operand B
			c					: in  std_logic_vector(31 downto 0); 	  -- operand C
			opcode			: in  std_logic_vector(2 downto 0) 	  	  -- opcode
        );
end entity operations;
    
    
architecture operations_arch of operations is
	 
	-- Build an enumerated type for the state machine
	type state_type is (s0, s1, s2, s3, s4, s5 , s6 , s7);

	-- Register to hold the current state
	signal state : state_type;
	
	-- signals for opcode processes
	signal result_add : std_logic_vector(63 downto 0);
	signal result_sub : std_logic_vector(63 downto 0);
	signal result_mul : std_logic_vector(63 downto 0);
	signal result_dec : std_logic_vector(63 downto 0);
	signal result_pas : std_logic_vector(63 downto 0);
	signal result_and : std_logic_vector(63 downto 0);

begin	

	process (clk, reset)
	begin

		if reset = '1' then
			state <= s0;

		elsif (rising_edge(clk)) then
		
			-- Determine the next state synchronously, based on
			-- the current state and the input
			case opcode is
				when "000" =>  state <= s0;	
				when "001" =>  state <= s1;
				when "010" =>  state <= s2;	
				when "011" =>  state <= s3;
				when "100" =>  state <= s4;
				when "101" =>  state <= s5;
				when "110" =>  state <= s6;
				when "111" =>  state <= s7;
				when others => state <= s0;
			end case;
		end if;
	end process;

	-- Determine the output based only on the current state
	process (state)
	begin
			case state is
				when s0=>

				when s1=>
					result_l <= result_add(31 downto 0);
					result_h <= result_add(63 downto 32);
						
				when s2=>
					result_l <= result_sub(31 downto 0);
					result_h <= result_sub(63 downto 32);
						
				when s3 =>
					result_l <= result_mul(31 downto 0);
					result_h <= result_mul(63 downto 32);
						
				when s4 =>
					result_l <= result_dec(31 downto 0);
					
				when s5 =>
					result_l <= result_pas(31 downto 0);
							
				when s6 => -- swap done in alu file
						
				when s7 =>
					result_l <= result_and(31 downto 0);
					result_h <= result_and(63 downto 32);
					
			end case;
	end process;
	
	
	process(clk) -- add
	begin
		if rising_edge(clk) then
			result_add <= x"00000000"  & std_logic_vector(signed(a) + signed(b));
		end if;
	end process;

	
	process(clk)  -- subtract
	begin
		if rising_edge(clk) then
			result_sub <= std_logic_vector(signed(a) - signed(b));
		end if;
	end process;	
	
	
	process(clk) -- multiply
	begin
		if rising_edge(clk) then
			result_mul <= std_logic_vector(signed(a) * signed(b));
		end if;	
	end process;

	
	process(clk) -- decrement
	begin
		if rising_edge(clk) then
			result_dec <= std_logic_vector(signed(b) - 1); 
		end if;
	end process;	
	
	
	process(clk) -- passthrough
	begin
		if rising_edge(clk) then
			result_pas <= x"00000000" & a;
		end if;
	end process;

	
	process(clk) -- AND or NAND
	begin
		if rising_edge(clk) then
			if c(0) = '1' then
				result_and <= not (a AND b);
			else
				result_and <= a AND b;
			end if;
		end if;
	end process;	
	

end architecture operations_arch;
    