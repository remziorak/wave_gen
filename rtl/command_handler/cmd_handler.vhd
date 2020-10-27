library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cmd_handler is
	
	port(
		clk		: in std_logic;
--		rst		: in std_logic;
		rx_data_ready	: in std_logic;
		rx_data		: in std_logic_vector (7 downto 0);
		tx_active	: in std_logic;
		sw		: in std_logic_vector (2 downto 0);
		cmd_ready	: out std_logic;
		cmd		: out std_logic_vector (15 downto 0);
		tx_send		: buffer std_logic;
		tx_data		: out std_logic_vector (7 downto 0)
	);

end entity cmd_handler;


architecture Behave of cmd_handler is
	type stateType is (idle, write_version, write_baudrate);
	signal state : stateType := idle;

	constant A 	    : std_logic_vector  (7 downto 0) := X"41";
	constant B 	    : std_logic_vector  (7 downto 0) := X"42";
	constant C 	    : std_logic_vector  (7 downto 0) := X"43";
	constant D  	: std_logic_vector  (7 downto 0) := X"44";
	constant la 	: std_logic_vector  (7 downto 0) := X"61";
	constant lb 	: std_logic_vector  (7 downto 0) := X"62";
	constant cmd_0 	: std_logic_vector  (7 downto 0) := X"30";
	constant cmd_1 	: std_logic_vector  (7 downto 0) := X"31";
	constant cmd_2 	: std_logic_vector  (7 downto 0) := X"32";
	constant cmd_3 	: std_logic_vector  (7 downto 0) := X"33";
	constant cmd_4 	: std_logic_vector  (7 downto 0) := X"34";
	constant cmd_5 	: std_logic_vector  (7 downto 0) := X"35";
	constant cmd_6 	: std_logic_vector  (7 downto 0) := X"36";
	constant cmd_7 	: std_logic_vector  (7 downto 0) := X"37";
	constant cmd_8 	: std_logic_vector  (7 downto 0) := X"38";
	constant cmd_9 	: std_logic_vector  (7 downto 0) := X"39";


	constant mem_word_depth	 : integer := 8;   	
	constant mem_word_length : integer := 8;
	signal 	 mem_addr_coeff  : integer range 0 to 7 := 0;
	signal 	 tx_data_count	 : integer range 0 to 31 := 0;


	
	type baud_ascii_memory is array (0 to mem_word_depth * 8 - 1 ) of std_logic_vector (mem_word_length - 1  downto 0);
	signal baud_ascii_mem : baud_ascii_memory := (--Hex values for baudrate array.
					X"0D", X"0A", X"31", X"31", X"35", X"32", X"30", X"30",   -- 115200
					X"0D", X"0A", X"35", X"37", X"36", X"30", X"30", X"20",   -- 57600
					X"0D", X"0A", X"33", X"38", X"34", X"30", X"30", X"20",   -- 38400 
					X"0D", X"0A", X"31", X"39", X"32", X"30", X"30", X"20",   -- 19200
					X"0D", X"0A", X"39", X"36", X"30", X"30", X"20", X"20",   -- 9600
					X"0D", X"0A", X"34", X"38", X"30", X"30", X"20", X"20",   -- 4800
					X"0D", X"0A", X"32", X"34", X"30", X"30", X"20", X"20",   -- 2400
					X"0D", X"0A", X"31", X"32", X"30", X"30", X"20", X"20"    -- 1200
                     );

	type version_ascii_memory is array (0 to 25) of std_logic_vector (mem_word_length -1 downto 0);
	signal version_ascii_mem : version_ascii_memory := (--Hex values for version information.
							X"0D",  
                            X"0A", -- New Line
							X"45", -- E
							X"6c", -- l
							X"65", -- e
							X"63", -- c
							X"74", -- t
							X"72", -- r
							X"61", -- a
							X"5f", -- _
							X"49", -- I
							X"43", -- C
							X"5f", -- -
							X"57", -- W
							X"61", -- a
							X"76", -- v
							X"65", -- e
							X"5f", -- _
							X"47", -- G
							X"65", -- e
							X"6e", -- n
							X"5f", -- -
							X"76", -- v
							X"30", -- 0
							X"31", -- 1
							X"20"  -- blank
							);


begin

	FSM : process(clk) is
	variable flag 	: boolean := False;
	variable tx_send_flag : boolean := False;
	begin
		--tx_send <= '0';
		if rising_edge(clk) then
			cmd_ready <= '0';  ----
			case(state) is
				when idle =>
					tx_send <= '0';
					tx_data <= (others => '0');
					
					if rx_data_ready = '1' then
						case (rx_data) is
							when A | B | C | D=>
								cmd_ready <= '0';  ----
								if flag = False then
									cmd(15 downto 8) <= rx_data;
									flag := True;
								end if;
								
							when la =>
								
								state <= write_version;
							--	tx_send <= '1';
								tx_data_count <= 0;
								tx_send_flag := False;
							
							when lb =>
								
								state <= write_baudrate;
								tx_data_count <= 0;
								tx_send_flag := False;
							
							when cmd_0 | cmd_1 | cmd_2 | cmd_3 | cmd_4 | cmd_5 | cmd_6 | cmd_7 | cmd_8 | cmd_9=>
								cmd_ready <= '0';  ----
								if flag = True then
									cmd(7 downto 0) <= rx_data;
									flag := False;
									cmd_ready <= '1';
								end if;
							when others =>
								state <= idle; 
						end case;
					end if;
				
				when write_version =>
						
						if tx_active = '0' then
							if tx_data_count = 25 then
							--	tx_data <= baud_ascii_mem((char_mem_depth * mem_addr_coeff) + tx_data_count );
								state <= idle;
								tx_data_count <= 0;
							--	tx_send <= '0';
							else
								tx_send <= '1';
								if tx_send_flag = True then
									tx_data_count <= tx_data_count + 1;
									tx_send_flag := False;
								else
									tx_send_flag := True;
								end if;
							end if;
							
							tx_data <= version_ascii_mem(tx_data_count );											
						else
							tx_send <= '0';
						end if;
						
			
				when write_baudrate =>
						
						if tx_active = '0' then
						    tx_data <= baud_ascii_mem((mem_word_depth * mem_addr_coeff) + tx_data_count );
							if tx_data_count = mem_word_length  then
							--	tx_data <= baud_ascii_mem((char_mem_depth * mem_addr_coeff) + tx_data_count );
								state <= idle;
								tx_data_count <= 0;
							else
								tx_send <= '1';
								if tx_send_flag = True then
									tx_data_count <= tx_data_count + 1;
									tx_send_flag  := False;
								else
									tx_send_flag  := True;
								end if;
											    	
							end if;
							--tx_data <= baud_ascii_mem((mem_word_depth * mem_addr_coeff - 1) + tx_data_count );
													else
                                tx_send <= '0';
						
				
						end if;
				
				when others =>
					state <= idle; 
			end case;

		end if;					
	

	end process FSM;

	
	calc_baud_mem_addr : process(clk)
	begin
		if rising_edge(clk) then
			mem_addr_coeff <= to_integer(unsigned(sw));
		end if;
	end process calc_baud_mem_addr;



end architecture Behave;


