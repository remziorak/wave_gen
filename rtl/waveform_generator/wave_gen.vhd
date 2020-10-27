library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--library xil_defaultlib;
--use xil_defaultlib.wave_gen_pkg.all;

library work;
use work.wave_gen_pkg.all;

entity wave_gen is
        port (
                clk             : in std_logic;
		        en 		        : in std_logic;
                cmd_ready       : in std_logic;
                wave_type       : in std_logic_vector (7 downto 0);
                wave_out        : out std_logic_vector (7 downto 0)
        );
end entity wave_gen;

architecture Behave of wave_gen is
	constant A      : std_logic_vector  (7 downto 0) := X"41";
    constant B      : std_logic_vector  (7 downto 0) := X"42";
    constant C      : std_logic_vector  (7 downto 0) := X"43";
    constant D      : std_logic_vector  (7 downto 0) := X"44";
	
	signal counter     : integer range 0 to 255 := 0;
	signal sin_counter : integer range 0 to 63 := 0;
	signal state       : stateType;
	signal direction   : boolean := True;
    signal sinState    : sinStateType := q1;	
    
begin
	FSM : process(clk) is
	begin
		if rising_edge(clk) then
			if cmd_ready = '1' then
				case (wave_type) is
					when A => 
						state <= saw_tooth;
					when B =>	
						state <= square;
					when C =>	
						state <= triangle;
					when D=>
					    state <= sin;
					when others =>	
						state <= saw_tooth;
				end case;
			end if;
		end if;
	end process FSM;


	gen_wave : process(clk) is
	begin
		if rising_edge(clk) then
			if en = '1' then
				case(state) is
					when saw_tooth =>
						if counter = 255 then
							counter <= 0;
						else
							counter <= counter + 1;
						end if;
						wave_out <= std_logic_vector(to_unsigned(counter,8));
					
					when square =>
                        if counter = 255 then
                            counter <= 0;		
                        else
                            counter <= counter + 1;
                        end if;
					
						if counter < 128 then
                            wave_out <= X"00";
						else
							wave_out <= X"FF";
						end if;

					when triangle =>
						
						if direction = True then
							if counter > 126 then
								direction <= False;
								counter <= counter - 1; ---
							else
								counter <= counter + 1;
							end if;
						else
							if counter = 0 then
								direction <= True ;
								counter <= counter + 1;
							else
								counter <= counter - 1;
							end if;
						end if;
						wave_out <= std_logic_vector(to_unsigned(counter * 2, 8));

                    when sin =>
                        case(sinState) is
                            when q1 =>
                    	       if sin_counter = 63 then
                    		      sinState <= q2;
                                else  
                    			  sin_counter <= sin_counter + 1;
                    			  
                    			end if;
                    			wave_out <= sin_table(sin_counter);          
                  	       
                    			      
                            when q2 =>
                    		      if sin_counter = 0 then
                    			     sinState <= q3;
                    			  else
                    			     sin_counter <= sin_counter - 1;
                    			
                    			  end if; 
                    			  wave_out <= sin_table(sin_counter);         
                    			         
                                  when q3 =>
                                     if sin_counter = 63 then
                                      sinState <= q4;
                            
                                    else
                                     sin_counter <= sin_counter + 1; 

                                    end if;
                                  wave_out <= std_logic_vector(to_unsigned(255 - to_integer(unsigned(sin_table(sin_counter))), 8)) ;        
                    			                 
                    			                     
                              when q4 =>            			         
                    		      if sin_counter = 0 then
                                    sinState <= q1;                                       
                                  else
                                    sin_counter <= sin_counter - 1;
                                  end if;
                                 wave_out <= std_logic_vector(255 - to_unsigned(to_integer(unsigned(sin_table(sin_counter))), 8)) ;           
                    			
                              when others =>
                                 sinState <= q1;         
                    	end case; 
				end case;
			end if;
		end if;
	end process gen_wave;

end architecture Behave;











