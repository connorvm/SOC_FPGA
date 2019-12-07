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
end entity qsys_alu;


architecture qsys_alu_arch of qsys_alu is 


    signal show_reg     : std_logic_vector(1 downto 0);
    signal a_reg        : std_logic_vector(1 downto 0);
    signal b_reg        : std_logic_vector(1 downto 0);
    signal h_reg        : std_logic_vector(1 downto 0);
    signal l_reg        : std_logic_vector(1 downto 0);

    signal show_byte    : std_logic_vector(7 downto 0);
    signal l_byte       : std_logic_vector(7 downto 0);
    signal ml_byte      : std_logic_vector(7 downto 0);
    signal mh_byte      : std_logic_vector(7 downto 0);
    signal h_byte       : std_logic_vector(7 downto 0);

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
                when "00" => show_byte <= l_byte;  --show low byte (7 downto 0)
                when "01" => show_byte <= ml_byte; --show mid-low byte (15 downto 8)
                when "10" => show_byte <= mh_byte; --show mid-high byte (23 downto 16)
                when "11" => show_byte <= h_byte;  --show high byte (31 downto 24)
                when others => show_byte <= x"00";
            end case ;

            if show_byte = l_byte then
                if show_reg = a_reg then
                    LED <= a(7 downto 0);
                elsif show_reg = b_reg then
                    LED <= b(7 downto 0);
                elsif show_reg = l_reg then
                    LED <= result_l(7 downto 0);
                elsif show_reg = h_reg then
                    LED <= result_h(7 downto 0);
                end if ;
                
            elsif show_byte = ml_byte then
                if show_reg = a_reg then
                    LED <= a(15 downto 8);
                elsif show_reg = b_reg then
                    LED <= b(15 downto 8);
                elsif show_reg = l_reg then
                    LED <= result_l(15 downto 8);
                elsif show_reg = h_reg then
                    LED <= result_h(15 downto 8);
                end if ;

            elsif show_byte = mh_byte then
                if show_reg = a_reg then
                    LED <= a(23 downto 16);
                elsif show_reg = b_reg then
                    LED <= b(23 downto 16);
                elsif show_reg = l_reg then
                    LED <= result_l(23 downto 16);
                elsif show_reg = h_reg then
                    LED <= result_h(23 downto 16);
                end if ;

            elsif show_byte = h_byte then
                if show_reg = a_reg then
                    LED <= a(31 downto 24);
                elsif show_reg = b_reg then
                    LED <= b(31 downto 24);
                elsif show_reg = l_reg then
                    LED <= result_l(31 downto 24);
                elsif show_reg = h_reg then
                    LED <= result_h(31 downto 24);
                end if ;
            
            else
                LED <= "00000000";
            end if ;
        end process;
        



end architecture qsys_alu_arch;