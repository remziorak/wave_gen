library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sync_data_gen is
	port (
		clk 		: in std_logic;
		en 		: in std_logic;
		edge_low	: in std_logic;
		wave		: in std_logic_vector(7 downto 0);
		sync		: out std_logic;
		dac_data	: out std_logic	
	);
end entity sync_data_gen;


architecture Behave of sync_data_gen is

	constant control_registers : std_logic_vector (7 downto 0) := "00110000";  -- LDAC, PDB := 1;  others=>0
	type stateType is (idle, shift_out, sync_data);
	signal state 		: stateType := idle;
	signal temp_data	: std_logic_vector (15 downto 0);
	signal shift_counter	: std_logic_vector (3 downto 0) :=X"0";

begin
	FSM :	process(clk) is
		begin
		if rising_edge(clk) then
			case (state) is
				when idle =>
				sync <= '1';
					if en = '1' then
						if edge_low = '1' then
							state <= shift_out;
							shift_counter <= X"0";
						end if;
					end if;
				temp_data <= control_registers & wave;
				

				when shift_out =>
					sync <= '0';		
					if edge_low = '1'  then 
						temp_data <= temp_data(14 downto 0) & temp_data(15);
						shift_counter <= std_logic_vector(unsigned(shift_counter) + 1);

						if shift_counter = X"F" then
							state <= sync_data;
						end if;
					end if;
						

					dac_data <= temp_data(15);
					

				when sync_data =>
					sync <= '1';
					shift_counter <= X"0";
						if en = '0' then
							state <= idle;
						end if;
			   when others =>
			         state <= idle;
					
			end case;
		end if;
	end process FSM;	



end architecture Behave;






