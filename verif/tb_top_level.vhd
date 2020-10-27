library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_top_level is
end entity tb_top_level;

architecture tb of tb_top_level is
	
	constant osc_freq 	: integer := 100000000;
	constant width    	: integer := 8;
	constant no_of_sample 	: integer := 16;
	
	constant t : time := 10 ns;

	signal clk 				:std_logic;
	signal sw 				:std_logic_vector (2 downto 0);
	signal sync				:std_logic;
	signal dac_data			:std_logic;
	signal s_clk			:std_logic;
	signal led				:std_logic_vector(7 downto 0);
		
	signal tx_dout_UUT1_to_UUT2 	: std_logic;
	signal uart_dout_UUT2_to_UUT1   : std_logic;
	signal tx_send_sig              : std_logic;
    signal tx_data_sig              : std_logic_vector(7 downto 0);
	signal tx_active_sig			: std_logic; 
	signal rx_data_ready_sig		: std_logic; 
	signal rx_data_sig				: std_logic_vector(7 downto 0); 

	signal Vout			:real;


begin
	
	UUT1_pc_transmitter : entity work.uart_top(struct)
		port map (
			clk		=> clk,
			sw		=> sw,
			rx_din		=> uart_dout_UUT2_to_UUT1, 
			tx_data		=> tx_data_sig,
			tx_send		=> tx_send_sig,
			tx_dout		=> tx_dout_UUT1_to_UUT2,
			tx_active	=> tx_active_sig,
			rx_data_ready	=> rx_data_ready_sig,
			rx_data		=> rx_data_sig
		);


	UUT2_top_level	: entity work.wave_gen_top(Struct)
		generic map ( 
			osc_freq 	=> osc_freq,
			width    	=> width,
			no_of_sample	=> no_of_sample
		)

		port map(
			clk 	 	=> clk,
			uart_din 	=> tx_dout_UUT1_to_UUT2, 
			sw  	 	=> sw,
			uart_dout	=> uart_dout_UUT2_to_UUT1,
			sync     	=> sync,
			dac_data 	=> dac_data,
			s_clk	 	=> s_clk,
			led	 	=> led 
		);

	UUT3_DAC_Model : entity work.DAC_RTL_sim_model(behav)
		generic map (
			Vdd 		=> 3.3,
			Vref		=> 3.3/2,
			N		=> 256
		)
	
		port map(
			sync		=> sync,
			d0		=> dac_data,		
			s_clk		=> s_clk,
			Vo		=> Vout
		);

	

	clk_generate : process
		begin
			clk <= '0';
			wait for t/2;
			clk <= '1';
			wait for t/2;	
		end process clk_generate;
		



	stimilus : process
		begin
		for sw_val in 0 to 7 loop				-- switch values are change between "000" to "111"
			tx_data_sig <= X"61";
			wait for t;
			tx_send_sig <= '1';
			wait for t;
			tx_send_sig <= '0';
			wait until tx_active_sig = '0';
			tx_data_sig <= X"62";
			wait for t;
			tx_send_sig <= '1';
			wait for t;
			tx_send_sig <= '0';
			wait for t;
			for wave in 65 to 68 loop			-- wave types = [ (A : X"41"), (B : X"42"), (C : X"43"), (D : X"44") ]
				for freq in 48 to 57 loop		-- frequency values are change between 0 to 9  (ascii => X"30" to X"39")
					sw <= std_logic_vector(to_unsigned(sw_val, 3));
					wait for t;			
					tx_data_sig <= std_logic_vector(to_unsigned(wave, 8));
					wait for t;
					tx_send_sig <= '1';
					wait for t;
					tx_send_sig <= '0';
					wait until tx_active_sig = '0';
					tx_data_sig <= std_logic_vector(to_unsigned(freq, 8));
					wait for t;
					tx_send_sig <= '1';
					wait for t;
					tx_send_sig <= '0';
					wait for t * 1000000;
				end loop;
			end loop;
		end loop;
		wait;
		end process stimilus;


end architecture tb;
