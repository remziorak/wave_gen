library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity wave_gen_top is
	generic( 
		osc_freq 	: integer := 100000000;
		width    	: integer := 8;
		no_of_sample	: integer := 16
		);
	port (
		clk 	 : in std_logic;
		uart_din : in std_logic; 
		sw  	 : in std_logic_vector (2 downto 0);
		uart_dout: out std_logic;
		sync     : out std_logic;
		dac_data : out std_logic;
		s_clk	 : out std_logic;
		led	 : out std_logic_vector (7 downto 0) 
		);
end entity wave_gen_top;

architecture Struct of wave_gen_top is
	signal rx_data_uart_top_to_cmd_handler 		: std_logic_vector (7 downto 0);
	signal rx_data_ready_uart_top_to_cmd_handler 	: std_logic;
	signal tx_data_cmd_handler_to_uart_top 		: std_logic_vector (7 downto 0);
	signal tx_send_cmd_handler_to_uart_top 		: std_logic;
	signal tx_active_cmd_handler_to_uart_top	: std_logic;
	signal cmd_ready_sig				: std_logic;   	
	signal cmd_sig 					: std_logic_vector (15 downto 0);
	signal en_out_sig				: std_logic;
	signal edge_low_sclk_gen_to_sync_data_gen	: std_logic;
	signal wave_out_sig				: std_logic_vector (7 downto 0);
begin

	uart_top_inst : entity work.uart_top(struct)
		generic map(
				osc_freq	=> osc_freq,
				width 	 	=> width,
				no_of_sample	=> no_of_sample	
		)

		port map(
			clk		=> clk,
			sw		=> sw,
			rx_din		=> uart_din,
			tx_data		=> tx_data_cmd_handler_to_uart_top,
			tx_send		=> tx_send_cmd_handler_to_uart_top,
			tx_dout		=> uart_dout,
			tx_active	=> tx_active_cmd_handler_to_uart_top, 
			rx_data_ready	=> rx_data_ready_uart_top_to_cmd_handler,
			rx_data		=> rx_data_uart_top_to_cmd_handler
			
		);
		
	cmd_handler_inst : entity work.cmd_handler(Behave)
		port map (
			clk		=> clk,
			rx_data_ready	=> rx_data_ready_uart_top_to_cmd_handler,
			rx_data		=> rx_data_uart_top_to_cmd_handler,
			tx_active	=> tx_active_cmd_handler_to_uart_top, 
			sw		=> sw,
			cmd_ready	=> cmd_ready_sig,
			cmd		=> cmd_sig,	 
			tx_send		=> tx_send_cmd_handler_to_uart_top,
			tx_data		=> tx_data_cmd_handler_to_uart_top
		
			
		);
		
	en_gen_inst : entity work.en_gen(Behave)
		port map(
			clk 		=> clk,
			cmd_ready 	=> cmd_ready_sig,
			freq		=> cmd_sig(7 downto 0),
			en_out		=> en_out_sig 
		);

	wave_gen_inst : entity work.wave_gen(Behave)
		port map(
			clk		=> clk,
			en		=> en_out_sig,
			cmd_ready	=> cmd_ready_sig,
			wave_type	=> cmd_sig(15 downto 8),
			wave_out	=> wave_out_sig
		);
		 


	sclk_gen_inst : entity work.sclk_gen(Behave)
		port map (
			clk 		=> clk,
			sclk 		=> s_clk,
			edge_low 	=> edge_low_sclk_gen_to_sync_data_gen
		);


	sync_data_gen_inst : entity work.sync_data_gen(Behave)
		port map(
			clk		=> clk,
			en		=> en_out_sig,
			edge_low 	=> edge_low_sclk_gen_to_sync_data_gen,
			wave		=> wave_out_sig,
			sync		=> sync,
			dac_data	=> dac_data	
		);

led <= wave_out_sig;	

end architecture Struct;





