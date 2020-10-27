library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uart_top is
	generic (
		osc_freq 	: integer := 100000000;
		width	 	: integer := 8;
		no_of_sample	: integer := 16
	);

	port(
		clk		:in std_logic;
		sw		:in std_logic_vector(2 downto 0);
		rx_din		:in std_logic;
		tx_data		:in std_logic_vector(width-1 downto 0);
		tx_send		:in std_logic;
		tx_dout		:out std_logic;
		tx_active	:buffer std_logic;	---
		rx_data_ready	:out std_logic;
		rx_data		:out std_logic_vector(width-1 downto 0)

	);
end entity uart_top;

architecture struct of uart_top is

	signal rx_active_sig_urx_to_baud_gen	  : std_logic;
	signal tx_active_sig_utx_to_baud_gen	  : std_logic;
	signal baud_en_tx_sig_baud_gen_to_utx 	  : std_logic;
	signal baud_en_rx_sig_baud_gen_to_urx	  : std_logic;
	--signal tx_active_sig_uart_top_to_baud_gen : std_logic;

begin
	baudrate_gen_inst : entity work.baudrate_gen(behav)
		generic map(
			osc_freq 	=> osc_freq,
			no_of_sample 	=> no_of_sample )
				
		port map(
			clk 		=> clk,
			sw		=> sw,
			rx_active	=> rx_active_sig_urx_to_baud_gen,
			tx_active	=> tx_active,
			baud_en_rx	=> baud_en_rx_sig_baud_gen_to_urx,
			baud_en_tx	=> baud_en_tx_sig_baud_gen_to_utx

		);


	u_tx_inst : entity work.u_tx(behav)
		generic map(
			width 		=> width,
			no_of_sample 	=> no_of_sample )
				
		port map(
			clk 		=> clk,
			tx_send		=> tx_send,
			data_in		=> tx_data,
			baud_en_tx	=> baud_en_tx_sig_baud_gen_to_utx,
			tx_data_out	=> tx_dout,
			tx_active	=> tx_active
		);

	u_rx_inst : entity work.u_rx(behav)
		generic map(
			width 		=> width,
			no_of_sample 	=> no_of_sample )
				
		port map(
			clk 		=> clk,
			data_in		=> rx_din,
		--	data_in		=> tx_dout,
			baud_en_rx	=> baud_en_rx_sig_baud_gen_to_urx,
			rx_active	=> rx_active_sig_urx_to_baud_gen,
			data_out	=> rx_data,	
			rx_data_ready	=> rx_data_ready
		);


end architecture struct;
