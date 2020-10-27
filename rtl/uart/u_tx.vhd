library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity u_tx is 
	generic(
		width : integer := 8;	-- UART width integer constant 
		no_of_sample : integer := 16 );		
	port(
		clk 			: in  std_logic ;							-- 100 MHz Clock
		tx_send 		: in std_logic ;							-- Send pulse signal. Uart starts to transmit (1)
		data_in 		: in std_logic_vector(width - 1 downto 0); 	-- TX bits data input from cmd_handler
		baud_en_tx 		: in std_logic ; 							-- The enable signal to take samples
		tx_data_out 	: out std_logic ;							-- One bit serial UART TX data connected to top level outout
		tx_active 		: out std_logic								-- UART is sending data when this signal asserted 


	);

end entity u_tx;

architecture behav of u_tx is 
	type stateType is (idle, send_start_bit, send_data, send_stop_bit);
	signal state : stateType := idle;
	signal pulse_count : integer := 0;
	signal tx_data_reg : std_logic;
	signal bits_reg : std_logic_vector (width - 1 downto 0);
	signal bit_index : integer := 0;
begin
	

	FSM : process(clk) is
	begin

	if rising_edge(clk) then
		case(state) is
			when idle =>
				tx_active <= '0';						
				tx_data_reg <= '1';
				if tx_send = '1' then
					state <= send_start_bit;
					bits_reg <= data_in;
					pulse_count <= 0;
					tx_active <= '1';
				end if;
			when send_start_bit =>					
				--tx_active <= '1';				
				tx_data_reg <= '0';			-- count baud pulses for one baud time
				bit_index <= 0;				-- Drive tx output yo the '0'
				if baud_en_tx = '1' then			-- After baud time is reached 
					if pulse_count = no_of_sample - 1 then	-- Go to the next state
						state <= send_data;
						pulse_count <= 0;	
					else
						pulse_count <= pulse_count + 1;
					end if;
		
				end if;
		
			when send_data =>
				tx_active <= '1';
				tx_data_reg <= bits_reg(bit_index);		
				if baud_en_tx = '1' then
					if pulse_count = no_of_sample - 1 then
						pulse_count <= 0;
						if bit_index = width - 1 then
							state <= send_stop_bit;
							bit_index <= 0;
						else
							bit_index <= bit_index + 1;
						end if;
					else
					pulse_count <= pulse_count + 1;
					end if;
				end if;

			when send_stop_bit =>
				tx_data_reg <= '1';
				if baud_en_tx = '1' then
					if pulse_count = no_of_sample - 1 then
					  	state <= idle;
						tx_active <= '0';	
					else
						pulse_count <= pulse_count +1;			
					end if;
				end if;

		end case;
	end if;
	end process FSM;

	tx_data_out <= tx_data_reg;

end architecture behav;
