

library ieee;
use ieee.std_logic_1164.all;


package wave_gen_pkg is 

	type stateType is(saw_tooth, square, triangle, sin);

    type sinStateType is (q1, q2, q3, q4);
    
	type sin_table_rom is array (0 to 63) of std_logic_vector (7 downto 0);

	constant sin_table : sin_table_rom := (
    X"80",	  X"83",	X"86",	  X"89",	X"8d",	  X"90",	X"93",	  X"96",	X"99",	  X"9c",	
    X"9f",    X"a2",    X"a5",    X"a8",    X"ab",    X"ae",    X"b1",    X"b4",    X"b7",    X"ba",    
    X"bd",    X"c0",    X"c2",    X"c5",    X"c8",    X"ca",    X"cd",    X"cf",    X"d2",    X"d4",    
    X"d6",    X"d9",    X"db",    X"dd",    X"df",    X"e1",    X"e3",    X"e5",    X"e7",    X"e9",    
    X"eb",    X"ec",    X"ee",    X"f0",    X"f1",    X"f2",    X"f4",    X"f5",    X"f6",    X"f7",    
    X"f8",    X"f9",    X"fa",    X"fb",    X"fc",    X"fc",    X"fd",    X"fe",    X"fe",    X"fe",    
    X"ff",    X"ff",    X"ff",    X"ff"
			);	
end package;

package body wave_gen_pkg is


end package body;
