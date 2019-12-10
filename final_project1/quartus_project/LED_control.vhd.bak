-- Author: Connor Van Meter
-- Lab Partner: Alex Salois


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_unsigned.all;

LIBRARY altera;
USE altera.altera_primitives_components.all;


entity LED_control is
    port(
        clk            : in  std_logic;                         -- system clock
        reset          : in  std_logic;                         -- system reset
        PB             : in  std_logic;                         -- Pushbutton to change state  
        SW             : in  std_logic_vector(3 downto 0);      -- Switches that determine next state
        HS_LED_control : in  std_logic;                         -- Software is in control when asserted (=1)
        SYS_CLKs_sec   : in  std_logic_vector(31 downto 0);     -- Number of system clock cycles in one second
        Base_rate      : in  std_logic_vector(7 downto 0);      -- base transition time in seconds, fixed-point data type
        LED_reg        : in  std_logic_vector(7 downto 0);      -- LED register
        LED            : out std_logic_vector(7 downto 0)       -- LEDs on the DE10-Nano board
    );
end entity LED_control;


architecture LED_arch of LED_control is
        
	-- Quartus Prime VHDL Template
	-- Four-State Mealy State Machine

	-- A Mealy machine has outputs that depend on both the state and
	-- the inputs.	When the inputs change, the outputs are updated
	-- immediately, without waiting for a clock edge.  The outputs
	-- can be written more than once per state or per clock cycle.


	-- Build an enumerated type for the state machine
	type state_type is (s0, s1, s2, s3, s4);

	-- Register to hold the current state
	signal state : state_type;
	
	
	signal s0_out 			: std_logic_vector(6 downto 0);
	signal s1_out 			: std_logic_vector(6 downto 0);
	signal s2_out			: std_logic_vector(6 downto 0);
	signal s3_out 			: std_logic_vector(6 downto 0);
	signal s4_out 			: std_logic_vector(6 downto 0);
	signal s0_pattern		: std_logic_vector(6 downto 0);
	signal s1_pattern 	: std_logic_vector(6 downto 0);
	signal s2_pattern 	: std_logic_vector(6 downto 0);
	signal s3_pattern 	: std_logic_vector(6 downto 0);
	signal s4_pattern 	: std_logic_vector(6 downto 0);
	signal br_clk     	: std_logic;
	signal br_clk2		   : std_logic;
	signal br_clk4     	: std_logic;
	signal base_div    	: std_logic_vector(39 downto 0);	-- number of times needed to count to get desired clock (has 4 fractional bits)
	signal br_clk_half 	: std_logic;
	signal PB1			 	: std_logic;
	signal PB_sync		 	: std_logic;
	signal LED_hb		 	: std_logic;
	signal show_state  	: std_logic_vector(6 downto 0);
	signal pb_hold		 	: std_logic;
	signal pb_assert	 	: std_logic;
	signal pb_cnt 			: std_logic_vector(40 downto 0);

  begin
  

	process (clk, reset)
	begin

		if reset = '1' then
			state <= s0;

		elsif (rising_edge(clk)) then

			-- Determine the next state synchronously, based on
			-- the current state and the input
			case state is
				when s0=>									---- State 0
					if SW = "0001" and PB = '1' then
						state <= s1;
				elsif SW = "0010" and PB = '1' then
						state <= s2;
				elsif SW = "0011" and PB = '1' then
						state <= s3;
				elsif SW = "0100" and PB = '1' then
						state <= s4;
					else
						state <= s0;
					end if;
					
				when s1=>									---- State 1
					if SW = "0000" and PB = '1' then
						state <= s0;
				elsif SW = "0010" and PB = '1' then
						state <= s2;
				elsif SW = "0011" and PB = '1' then
						state <= s3;
				elsif SW = "0100" and PB = '1' then
						state <= s4;
					else
						state <= s1;
					end if;
					
				when s2=>									---- State 2
					if SW = "0001" and PB = '1' then
						state <= s1;
				elsif SW = "0000" and PB = '1' then
						state <= s0;
				elsif SW = "0011" and PB = '1' then
						state <= s3;
				elsif SW = "0100" and PB = '1' then
						state <= s4;
					else
						state <= s2;
					end if;
					
				when s3=>									---- State 3
					if SW = "0001" and PB = '1' then
						state <= s1;
				elsif SW = "0010" and PB = '1' then
						state <= s2;
				elsif SW = "0000" and PB = '1' then
						state <= s0;
				elsif SW = "0100" and PB = '1' then
						state <= s4;
					else
						state <= s3;
					end if;
					
				when s4=>									---- State 4
					if SW = "0001" and PB = '1' then
						state <= s1;
				elsif SW = "0010" and PB = '1' then
						state <= s2;
				elsif SW = "0011" and PB = '1' then
						state <= s3;
				elsif SW = "0000" and PB = '1' then
						state <= s0;
					else state <= s4;
					
				end if;	
			end case;
		end if;

	end process;

	-- Determine the output based only on the current state
	-- and the input (do not wait for a clock edge).
	process (state, SW)
		begin
			case state is
				when s0=>
					LED(6 downto 0) <= s0_out;
					
				when s1=>
					LED(6 downto 0) <= s1_out;
					
				when s2=>
					LED(6 downto 0) <= s2_out;
				
				when s3=>
					LED(6 downto 0) <= s3_out;
				
				when s4=>
					LED(6 downto 0) <= s4_out;			
					
			end case;
	end process;
	
	
	process (clk)
	 begin
	 
		base_div <= std_logic_vector(unsigned(sys_clks_sec) * unsigned(base_rate));
	 end process;


	 
-- Counter
	process (clk)
		variable   cnt : integer;
	begin
		if (rising_edge(clk)) then

			if reset = '1' then
				-- Reset the counter to 0
				cnt := 0;

			else 
				-- 
			 if cnt <= base_div(39 downto 4) then
				 cnt := cnt + 1;
				 
			 else 
				 cnt := 0;
				 br_clk <= not br_clk;
				 
			 end if;
			end if;
		end if;

	end process;
	
	process (clk)
		variable   cnt : integer;
	begin
		if (rising_edge(clk)) then

			if reset = '1' then
				-- Reset the counter to 0
				cnt := 0;

			else 
				-- 
			 if cnt <= base_div(39 downto 5) then
				 cnt := cnt + 1;
				 
			 else 
				 cnt := 0;
				 br_clk2 <= not br_clk2;
				 
			 end if;
			end if;
		end if;

	end process;
	
	process (clk)
		variable   cnt : integer;
	begin
		if (rising_edge(clk)) then

			if reset = '1' then
				-- Reset the counter to 0
				cnt := 0;

			else 
				-- 
			 if cnt <= base_div(39 downto 6) then
				 cnt := cnt + 1;
				 
			 else 
				 cnt := 0;
				 br_clk4 <= not br_clk4;
				 
			 end if;
			end if;
		end if;

	end process;
	
	process (clk)
		variable   cnt : integer;
	begin
		if (rising_edge(clk)) then

			if reset = '1' then
				-- Reset the counter to 0
				cnt := 0;

			else 
				-- 
			 if cnt <= base_div(39 downto 3) then
				 cnt := cnt + 1;
				 
			 else 
				 cnt := 0;
				 br_clk_half <= not br_clk_half;
				 
			 end if;
			end if;
		end if;

	end process;

	-- Heartbeat LED that beats no matter what --
	process (clk)
	begin
	
		if (rising_edge(br_clk)) then
			LED_hb <= not LED_hb;
		end if;
			LED(7) <= LED_hb;
	end process;
	-----------------------------------------------
		
	
	-- Process to determine what to do in state0 --
	process (clk, reset)	-- Shift one lit LED to the right at 2 * Base_rate Hz
	begin
	

		--s0_out <= "0000001";	-- set LEDs to 000001
		if reset = '1' then
			s0_pattern <= "0000001";	-- if reset, turn off LEDs

		elsif (rising_edge(br_clk2)) then
			s0_pattern <= s0_pattern(0) & s0_pattern(6 downto 1);
		end if;	
	end process; 
	
	
	-- Process to determine what to do in state1 --
	process (clk, reset)	-- two lit LEDs, side-by-side, shifting left at 4 * Base_rate Hz
		variable   cnt : integer;
	begin
	
		--s1_out <= "0000010";	-- set LEDs to 000010
		if reset = '1' then
			s1_pattern <= "0000011";	-- if reset, turn off LEDs
		
		elsif (rising_edge(br_clk4)) then
			s1_pattern <= s1_pattern(4 downto 0) & s1_pattern(6 downto 5);
		end if;	
	end process;
		
	
	-- Process for state2 --
	process (clk)		-- 7-bit up counter
		variable   cnt : integer;
	begin
		if (rising_edge(br_clk)) then

			if reset = '1' then
				-- Reset the counter to 0
				cnt := 0;

			else 
				if cnt <= 127 then
					cnt := cnt + 1;
				 
				else 
					cnt := 0;
				 
				end if;
			end if;
				s2_pattern <= std_logic_vector(to_unsigned(cnt, 7));
		end if;

	end process;
	
	
	-- Process for state3 --
	process (clk)		-- 7-bit down counter
		variable   cnt : integer;
	begin
		if (rising_edge(br_clk4)) then

			if reset = '1' then
				-- Reset the counter to 0
				cnt := 0;

			else 
				if cnt <= 127 then
				 cnt := cnt - 1;
				 
				else 
				 cnt := 127;
				 
			 end if;
			end if;
			s3_pattern <= std_logic_vector(to_unsigned(cnt, 7));
		end if;
	end process;
	
	
	-- Process for state4 -- USER DEFINED PATTERN
	process (clk)		-- Counter counts by 2 and nibble swaps
		variable   cnt : integer;
	begin
		if (rising_edge(br_clk)) then

			if reset = '1' then
				-- Reset the counter to 0
				cnt := 0;

			else 
				if br_clk_half = '1' then
					s4_pattern <= std_logic_vector(to_unsigned(cnt, 7));
					if cnt <= 127 then
						cnt := cnt + 1;
					else 
						cnt := 0;
					end if;
				else
					s4_pattern <= s4_pattern(3 downto 0) & s4_pattern(6 downto 4);
			end if;
		  end if;
		end if;
	end process;
	
	
		-- state output
	process(clk)
		begin
		if (rising_edge(clk)) then
			if pb_hold = '1' then
				s0_out <= show_state;
				s1_out <= show_state;
				s2_out <= show_state;
				s3_out <= show_state;
				s4_out <= show_state;
			else
				s0_out <= s0_pattern;
				s1_out <= s1_pattern;
				s2_out <= s2_pattern;
				s3_out <= s3_pattern;
				s4_out <= s4_pattern;
			end if;
		end if;
	end process;
	
	-- shows current state
	process(clk)
		begin
		if (rising_edge(clk)) then
			 case state is
				when s0=>
					show_state <= "0000000";
				when s1=>
					show_state <= "0000001";
				when s2=>
					show_state <= "0000010";
				when s3=>
					show_state <= "0000011";			
				when s4=>
					show_state <= "0000100";			
			end case;
		end if;
	end process;
	

	process(clk)
		begin
		if rising_edge(clk) then
			if PB = '1' then 
				pb_assert <= '1';
				--pb_cnt <= base_div(39 downto 4;)
			else
				pb_assert <= '0';
			end if;
		end if;
	end process;
		
	-- count for sec and leave pb_hold 1
	process(clk)
		variable   cnt	: integer;
		begin
		if(rising_edge(clk)) then
			if pb_assert = '1' then
				cnt := 0;
			else
				if cnt < base_div(39 downto 4) then
					cnt := cnt + 1;
					pb_hold <= '1';
				else 
					cnt := to_integer(unsigned(base_div(39 downto 4)));
					pb_hold <= '0';
				end if;
			end if;
		end if;
	end process;
	



end architecture LED_arch;