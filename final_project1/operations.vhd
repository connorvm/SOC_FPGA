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
			status			: out std_logic_vector(31 downto 0); 	  -- status flags
			a					: in  std_logic_vector(31 downto 0); 	  -- input regs
			b					: in  std_logic_vector(31 downto 0); 	  -- 
			c					: in  std_logic_vector(31 downto 0); 	  -- 
			opcode			: in  std_logic_vector(2 downto 0); 	  -- opcode
			op_change		: in 	std_logic
        );
end entity operations;
    
    
architecture operations_arch of operations is
	 
	-- Build an enumerated type for the state machine
	type state_type is (s0, s1);

	-- Register to hold the current state
	signal state : state_type;
	
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
			case state is
				when s0=>
					if op_change = '1' then
						state <= s1;
					else
						state <= s0;
					end if;
				when s1=>
					if op_change = '1' then
						state <= s1;
					else
						state <= s0;
					end if;
			end case;

		end if;
	end process;

	-- Determine the output based only on the current state
	-- and the input (do not wait for a clock edge).
	process (state, op_change)
	begin
			case state is
				when s0=>

				when s1=>
					case opcode is
						when "000" => 
						
						when "001" =>
							result_l <= result_add(31 downto 0);
							result_h <= result_add(63 downto 32);
						
						when "010" => 
							result_l <= result_sub(31 downto 0);
							result_h <= result_sub(63 downto 32);
						
						when "011" =>
							result_l <= result_mul(31 downto 0);
							result_h <= result_mul(63 downto 32);
						
						when "100" =>

						
						when "101" =>
							result_l <= result_pas(31 downto 0);
							
						when "110" => 
						
						when "111" =>
							result_l <= result_and(31 downto 0);
							result_h <= result_and(63 downto 32);
						
					end case;
			end case;
	end process;
	
	process(clk)
	begin
		if rising_edge(clk) then
			-- add
		end if;
	end process;

		process(clk)
	begin
		if rising_edge(clk) then
			-- sub
		end if;
	end process;	
	
	process(clk)
	begin
		if rising_edge(clk) then
			-- mul
		end if;	
	end process;

	process(clk)
	begin
		if rising_edge(clk) then
			-- dec
			result_dec <= std_logic_vector(signed(b) - 1); 
		end if;
	end process;	
	
	process(clk)
	begin
		if rising_edge(clk) then
			-- passthrough
			result_pas <= x"00000000" & a;
		end if;
	end process;

	process(clk)
	begin
		if rising_edge(clk) then
			-- and 
			if c(0) = '1' then
				result_and <= not (a AND b);
			else
				result_and <= a AND b;
			end if;
		end if;
	end process;	
	









end architecture operations_arch;
    