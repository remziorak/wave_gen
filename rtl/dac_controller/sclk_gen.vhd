library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sclk_gen is
	port (
		clk  	: in std_logic;
		sclk 	: buffer std_logic;
		edge_low: out std_logic
		);

end entity sclk_gen;

architecture Behave of sclk_gen is
	signal counter : std_logic_vector (3 downto 0) := X"0";
begin
	process (clk)is
	begin
	
		edge_low <= counter(1) and  counter(0);
		sclk <= not counter(1);	
		if rising_edge(clk) then
			counter <= std_logic_vector(unsigned(counter) + 1);
			
		end if;
		
			
	end process;
	


end architecture Behave;

