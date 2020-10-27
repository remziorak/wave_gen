library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity baudrate_gen is 
	generic(
		osc_freq : integer := 100000000; 
		no_of_sample : integer := 16 );		
	
	port(
		clk : in std_logic;			-- 100 MHz Clock
		sw : in std_logic_vector (2 downto 0);	-- 3 bit switch bus connected to the sw on the board
	--	rst :in std_logic ;			-- Reset signal
		rx_active : in std_logic;		-- Receive active signal
		tx_active : in std_logic;		-- Transmit active signal
		baud_en_rx : buffer std_logic;		-- Baudrate ticks signal for uart receiver
		baud_en_tx : buffer std_logic );	-- Baudrate ticks signal for uart transmitter
end baudrate_gen;

architecture behav of baudrate_gen is
	signal count_tx : integer :=0;
	signal count_rx : integer :=0;
	signal clk_div_tx : integer;
	signal clk_div_rx : integer;
begin

div_tx : process(clk)
begin
	if rising_edge(clk) then
		case(sw)is
			when "000" => clk_div_tx <= ((osc_freq /115200) / no_of_sample)- 1;	--115200 Baud Rate
			when "001" => clk_div_tx <= ((osc_freq /57600) / no_of_sample)- 1;	--57600 Baud Rate
			when "010" => clk_div_tx <= ((osc_freq /38400) / no_of_sample)- 1;	--38400 Baud Rate
	  		when "011" => clk_div_tx <= ((osc_freq /19200) / no_of_sample)- 1;	--19200 Baud Rate
			when "100" => clk_div_tx <= ((osc_freq /9600) / no_of_sample)- 1;	--9600 Baud Rate
			when "101" => clk_div_tx <= ((osc_freq /4800) / no_of_sample)- 1;	--4800 Baud Rate
			when "110" => clk_div_tx <= ((osc_freq /2400) / no_of_sample)- 1;	--2400 Baud Rate
			when "111" => clk_div_tx <= ((osc_freq /1200) / no_of_sample)- 1;	--1200 Baud Rate
			when others => clk_div_tx <=((osc_freq /115200) / no_of_sample)- 1;	--115200 (Default)
		end case;
	
	end if;
end process div_tx;



div_rx : process(clk)
begin
	if rising_edge(clk) then
		case(sw)is
			when "000" => clk_div_rx <= ((osc_freq /115200) / no_of_sample) - 1;	--115200 Baud Rate
			when "001" => clk_div_rx <= ((osc_freq /57600) / no_of_sample) - 1;	--57600 Baud Rate
			when "010" => clk_div_rx <= ((osc_freq /38400) / no_of_sample) - 1;	--38400 Baud Rate
	  		when "011" => clk_div_rx <= ((osc_freq /19200) / no_of_sample) - 1;	--19200 Baud Rate
			when "100" => clk_div_rx <= ((osc_freq /9600) / no_of_sample) - 1;	--9600 Baud Rate
			when "101" => clk_div_rx <= ((osc_freq /4800) / no_of_sample) - 1;	--4800 Baud Rate
			when "110" => clk_div_rx <= ((osc_freq /2400) / no_of_sample) - 1 ;	--2400 Baud Rate
			when "111" => clk_div_rx <= ((osc_freq /1200) / no_of_sample) - 1;	--1200 Baud Rate
			when others => clk_div_rx <= ((osc_freq /115200) / no_of_sample) -1 ;	--115200 (Default)
		end case;
	
	end if;
end process div_rx;




clock_div_tx : process(clk)
begin
	
	if rising_edge(clk) then
		baud_en_tx <= '0';
		count_tx <= 0;
		if tx_active = '1' then
			count_tx <= count_tx + 1;
			if count_tx > clk_div_tx  then
				baud_en_tx <= not baud_en_tx;
				count_tx <= 0;
			end if;
		end if;
	end if;
			

end process clock_div_tx;	 


clock_div_rx : process(clk)
begin
	if rising_edge(clk) then
		baud_en_rx <= '0';
		count_rx <= 0;
		if rx_active = '1' then
			count_rx <= count_rx + 1;
			if count_rx > clk_div_rx  then
				baud_en_rx <= not baud_en_rx;
				count_rx <= 0;
			end if;
		end if;
	end if;
	
end process clock_div_rx;

end architecture behav;

