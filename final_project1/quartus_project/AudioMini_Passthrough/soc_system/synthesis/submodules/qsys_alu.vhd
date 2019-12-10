
-- Authors: Connor Van Meter, Alex Salois


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_unsigned.all;

LIBRARY altera;
USE altera.altera_primitives_components.all;

--need to know the registers(a, b, high, low) and switches
--output just ledss?

entity qsys_alu is
    port(
			clk            	: in  std_logic;                       
			reset_n        	: in  std_logic;                       
			avs_s1_address		: in  std_logic_vector(2 downto 0);
			avs_s1_write		: in  std_logic; 
			avs_s1_writedata	: in  std_logic_vector(31 downto 0);
			avs_s1_read			: in  std_logic;
			avs_s1_readdata	: out std_logic_vector(31 downto 0);  		
			switches         	: in  std_logic_vector(3 downto 0);
			pushbutton			: in 	std_logic;
			leds            	: out std_logic_vector(7 downto 0)       
    );
end entity qsys_alu;


architecture qsys_alu_arch of qsys_alu is 

component alu is
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
end component alu;

    signal show_reg     : std_logic_vector(31 downto 0);
    signal a_reg        : std_logic_vector(31 downto 0);
    signal b_reg        : std_logic_vector(31 downto 0);
	 signal c_reg			: std_logic_vector(31 downto 0);
    signal h_reg        : std_logic_vector(31 downto 0);
    signal l_reg        : std_logic_vector(31 downto 0);
	 signal opcode			: std_logic_vector(2 downto 0);
	 signal status			: std_logic_vector(2 downto 0);

    signal show_byte    : std_logic_vector(7 downto 0);
    signal l_byte       : std_logic_vector(7 downto 0);
    signal ml_byte      : std_logic_vector(7 downto 0);
    signal mh_byte      : std_logic_vector(7 downto 0);
    signal h_byte       : std_logic_vector(7 downto 0);

    begin
	 
	 Ualu : component alu
	     port map(
			clk		=> clk,
			reset    => not reset_n,-- system reset
			result_h	=> h_reg, 	  	-- results
			result_l	=> l_reg, 	  	-- results
			status	=> status,  		-- status flags
			a			=> a_reg, 		-- input regs
			b			=> b_reg, 		-- 
			c			=> c_reg,	 		-- 
			opcode	=> opcode	  -- opcode
    );

        --Switches[3-2] controls which register is selected
        --Switches[1-0] controls which byte in register is shown
        process (clk)
        begin
		  if rising_edge(clk) then
            case switches(3 downto 2) is
                when "00" => show_reg <= a_reg; --when 0, display Register a
                when "01" => show_reg <= b_reg; --when 1, display Register b
                when "10" => show_reg <= l_reg; --when 2, display Low Register
                when "11" => show_reg <= h_reg; --when 3, display High Register
                when others => show_reg <= x"00000000";
            end case;

            case switches(1 downto 0) is
                when "00" => show_byte <= show_reg(7 downto 0);  --show low byte (7 downto 0)
                when "01" => show_byte <= show_reg(15 downto 8); --show mid-low byte (15 downto 8)
                when "10" => show_byte <= show_reg(23 downto 16); --show mid-high byte (23 downto 16)
                when "11" => show_byte <= show_reg(31 downto 24);  --show high byte (31 downto 24)
                when others => show_byte <= x"00";
            end case ;
				
				leds <= show_byte;
				end if;
				end process;
				
				process(clk) is
				begin
				if rising_edge(clk) and avs_s1_read ='1' then
					case avs_s1_address is
						when "000" => avs_s1_readdata <= a_reg;
						when "001" => avs_s1_readdata <= b_reg;
						when "010" => avs_s1_readdata <= x"0000000" & "0" & opcode;
						when "011" => avs_s1_readdata <= l_reg;
						when "100" => avs_s1_readdata <= h_reg;
						when "101" => avs_s1_readdata <= x"0000000" & "0" & status;
						when "110" => avs_s1_readdata <= c_reg; 
						when others => avs_s1_readdata <= (others => '0'); -- return zeros for undefined registers
					end case;
				end if;
				end process;
		
				process(clk) is
				begin
				if rising_edge(clk) and avs_s1_write='1' then
					case avs_s1_address is
						when "000" => a_reg 	<= avs_s1_writedata;
						when "001" => b_reg 	<= avs_s1_writedata;
						when "010" => opcode <= avs_s1_writedata(2 downto 0);
						when "110" => c_reg <= avs_s1_writedata; 
						when others => null;
					end case;
				end if;
				end process;
        



end architecture qsys_alu_arch;