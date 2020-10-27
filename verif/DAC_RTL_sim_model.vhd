library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity DAC_RTL_sim_model is
	generic (
		Vdd : real := 3.3;
		Vref: real := 3.3/2;
		N   : integer := 256
	);

	port(
		sync 	: in std_logic;
		d0   	: in std_logic;
		s_clk 	: in std_logic;
		Vo	: out real
	);
end entity;

architecture behav of DAC_RTL_sim_model is
	constant control_registers : std_logic_vector (7 downto 0) := "00110000";  -- LDAC, PDB := 1;  others=>0
	signal temp16_data : std_logic_vector (15 downto 0);
	signal temp8_data  : std_logic_vector (7 downto 0);
	type stateType is (idle, receive);
	signal state : stateType := idle;

begin
	process (sync)is
	begin
		if sync = '0' then
			state <= receive;
		else 
			state <= idle;
		end if;
	end process;		
		
	process (s_clk) is
	begin
		if rising_edge(s_clk) then
			case(state) is
				when idle =>
					temp8_data <= temp16_data(7 downto 0);									

				when receive =>
					temp16_data <= temp16_data(14 downto 0) & d0;
			end case;
			Vo <= real(2) * Vref * real(to_integer(unsigned(temp8_data))) / real(256) ; 	
		end if;
	end process;



end architecture behav;
