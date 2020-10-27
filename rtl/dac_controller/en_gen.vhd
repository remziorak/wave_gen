library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity en_gen is
	port (
		clk 		: in std_logic;
		cmd_ready 	: in std_logic;
		freq		: in std_logic_vector (7 downto 0);
		en_out		: buffer std_logic
	);
end entity en_gen;

architecture Behave of en_gen is

signal counter_limit : integer range 0 to 1000 := 1000;
signal counter 	     : integer range 0 to 1000 := 0;
begin

	def_count_lim : process(clk) is
	begin
		if rising_edge(clk) then
			if cmd_ready = '1' then
				case (freq) is
					when X"30" =>
						counter_limit <= 1000;
					when X"31" =>
						counter_limit <= 900;				
					when X"32" =>
						counter_limit <= 800;	
					when X"33" =>
						counter_limit <= 700;
					when X"34" =>
						counter_limit <= 600;
					when X"35" =>
						counter_limit <= 500;
					when X"36" =>
						counter_limit <= 400;
					when X"37" =>
						counter_limit <= 300;				
					when X"38" =>
						counter_limit <= 200;	
					when X"39" =>
						counter_limit <= 100;
					when others =>
						counter_limit <= 1000;
				end case;
			end if;
		end if;
	end process def_count_lim;

	gen_en_sig : process(clk) is
	begin
		
		if rising_edge(clk) then
                        en_out <= '0';
			if counter >= counter_limit then
				en_out <= not en_out;
				counter <= 0;
			else
				counter <= counter + 1;
			end if;
		end if;
	
	end process gen_en_sig;


end architecture Behave;






