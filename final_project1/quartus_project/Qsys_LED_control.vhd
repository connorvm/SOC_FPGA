library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_unsigned.all;

LIBRARY altera;
USE altera.altera_primitives_components.all;

entity Qsys_led_control is
    port(
			clk            	: in  std_logic;                       
			reset_n        	: in  std_logic;                       
			avs_s1_address		: in  std_logic_vector(1 downto 0);
			avs_s1_write		: in  std_logic; 
			avs_s1_writedata	: in  std_logic_vector(31 downto 0);
			avs_s1_read			: in  std_logic;
			avs_s1_readdata	: out std_logic_vector(31 downto 0);  		
			switches         	: in  std_logic_vector(3 downto 0);
			pushbutton			: in 	std_logic;
			leds            	: out std_logic_vector(7 downto 0)       
    );
end entity Qsys_led_control;

architecture Qsys_led_arch of Qsys_led_control is

	signal sec		: 	std_logic_vector(31 downto 0) := std_logic_vector(to_unsigned(50000000,32));
	signal b_rate	: 	std_logic_vector(7 downto 0) 	:= "00010000";
	signal h_cont	: 	std_logic 							:= '0';
	signal led_hw	:	std_logic_vector(7 downto 0)	:=	"00000000";
	signal led_reg : 	std_logic_vector(7 downto 0)	:= "10101010";
	signal pb_sync	: 	std_logic;
	
	component PB_condition is
   port(	clk    	: in  std_logic;                         -- system clock
         reset   	: in  std_logic;                         -- system reset
         pb      	: in  std_logic;                          -- Pushbutton to change state
         pb_sync 	: out std_logic);
	end component PB_condition;

	component led_control is
   port(
        clk            : in  std_logic;                         -- system clock
        reset          : in  std_logic;                         -- system reset
        PB             : in  std_logic;                         -- Pushbutton to change state  
        SW             : in  std_logic_vector(3 downto 0);      -- Switches that determine next state
        hs_led_control : in  std_logic;								 --Software is in control when asserted (=1)
        sys_clks_sec   : in  std_logic_vector(31 downto 0);     -- Number of system clock cycles in one second
        base_rate      : in  std_logic_vector(7 downto 0);      -- base transition time in seconds, fixed-point data type
        led_reg        : in  std_logic_vector(7 downto 0);      -- led register
        led            : out std_logic_vector(7 downto 0)       -- leds on the DE10-Nano board
    );
	end component led_control;
	
begin

	U1 : PB_condition 
	port map(
		clk     => clk,                         
      reset   => not reset_n,                         
      PB      => not pushbutton,                                     
		PB_sync => PB_sync
		);

	U10 : component led_control 
	port map(
		clk            => clk,
      reset     		=> not reset_n,
      PB             => PB_sync,  
      SW             => switches,
      HS_led_control => h_cont,
      sys_clks_sec   => sec,
      base_rate      => b_rate,
      led_reg        => led_reg,
      led            => led_hw
    );
	 
	 
	 -- Software Control
	 process(clk) is
		begin
			if rising_edge(clk) then
				if h_cont = '1' then
					leds <= led_reg;
				else
					leds <= led_hw;
				end if;
			end if;
		end process;
	 
	process(clk) is
		begin
		if rising_edge(clk) and avs_s1_read ='1' then
			case avs_s1_address is
				when "00" => avs_s1_readdata <= std_logic_vector(to_unsigned(0,31)) & h_cont;
				when "01" => avs_s1_readdata <= sec;
				when "10" => avs_s1_readdata <= std_logic_vector(to_unsigned(0,24)) & led_reg;
				when "11" => avs_s1_readdata <= std_logic_vector(to_unsigned(0,24)) & b_rate;
				when others => avs_s1_readdata <= (others => '0'); -- return zeros for undefined registers
			end case;
		end if;
	end process;
	
	process(clk) is
		begin
		if rising_edge(clk) and avs_s1_write='1' then
			case avs_s1_address is
				when "00" => h_cont 	<= avs_s1_writedata(0);
				when "01" => sec 		<= avs_s1_writedata;
				when "10" => led_reg	<= avs_s1_writedata(7 downto 0);
				when "11" => b_rate 	<= avs_s1_writedata(7 downto 0);
				when others => null;
			end case;
		end if;
	end process;

end architecture Qsys_led_arch;
