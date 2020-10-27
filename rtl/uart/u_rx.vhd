library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity u_rx is
	generic(
		width : integer := 8;
		no_of_sample : integer := 16
	);
	port (
		clk 		:in std_logic; 					-- 100 Mhz Clock
		data_in		:in std_logic;					-- UART RX input
		baud_en_rx	:in std_logic;					-- The enable signal to take samples
		rx_active	:out std_logic;					-- Asserted when data is receiving
		data_out	:out std_logic_vector (width-1 downto 0); 	-- Received data connected to cmd_handler
		rx_data_ready	:out std_logic					-- Ready signal which shows data_out is ready
	);
end entity u_rx;


architecture behav of u_rx is
	type stateType is (idle, wait_mid_of_start_bit, receive_data, receive_stop_bit);	
	signal state 	 		: stateType := idle;
	signal sync1_reg 		: std_logic;
	signal sync2_reg 		: std_logic;
	signal sync_rx	 		: std_logic;	
	signal pulse_count 		: integer range 0 to 15 := 0;
	signal bit_index		: integer range 0 to 7  := 0;
	signal bits_reg 		: std_logic_vector (width-1 downto 0);
	signal rx_data_ready_buff 	: std_logic;
begin

	sync_async_rx : process(clk)
	begin
		if rising_edge(clk) then
			sync1_reg <= data_in;
			sync2_reg <= sync1_reg;
		end if;
	end process sync_async_rx;

	sync_rx <= sync2_reg ;


	FSM : process(clk)
	begin	
		if rising_edge(clk) then
			case(state) is
				when idle =>
					rx_data_ready_buff <= '0';
					rx_active <= '0';
					if sync_rx = '0' then
						state <= wait_mid_of_start_bit;
						pulse_count <= 0;
					end if;		
				
				when wait_mid_of_start_bit =>
					rx_data_ready_buff <= '0';
					rx_active <= '1';
					if baud_en_rx = '1' then
						if pulse_count = (no_of_sample / 2) - 1 then
							if sync_rx = '0' then
								state <= receive_data;
								pulse_count <= 0;
								bit_index <= 0;
							else
								state <= idle;		
							end if;
						else
							pulse_count <= pulse_count + 1;
						end if;		
					end if;
									
				when receive_data =>
					rx_data_ready_buff <= '0';
					rx_active <= '1';
					if baud_en_rx ='1' then
						if pulse_count = no_of_sample - 1 then
							pulse_count <= 0;	
							bits_reg <= sync_rx & bits_reg(7 downto 1);	
							if bit_index = width - 1 then
								state <= receive_stop_bit;
							else
								bit_index <= bit_index + 1;
							end if;
						else
							pulse_count <= pulse_count + 1;
						end if;
					end if;
				
				when receive_stop_bit =>
					rx_active <= '1';
					if baud_en_rx = '1' then
						if pulse_count = no_of_sample - 1 then
							if rx_data_ready_buff <= '1' then
								state <= idle;
							end if;
							
							if sync_rx = '1' then
								rx_data_ready_buff <= '1';
								rx_active <= '0';
							else
								state <= idle;
							end if;
						else
							pulse_count <= pulse_count + 1 ;
						end if;
						

					end if;
			end case;	
		end if;
	end process FSM;

	data_out <= bits_reg;
	rx_data_ready <= rx_data_ready_buff;	

end architecture behav;
