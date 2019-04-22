LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY ram_256x16 IS
	PORT
	(
		data			: IN  std_logic_vector(15 DOWNTO 0);
		address			: IN  std_logic_vector(7 DOWNTO 0);
		we				: IN  std_logic;
		cs				: IN  std_logic;
		q				: OUT std_logic_vector(15 DOWNTO 0)
	);
END ram_256x16;

ARCHITECTURE rtl OF ram_256x16 IS
	TYPE RAM IS ARRAY(0 TO 256) OF std_logic_vector(15 DOWNTO 0);

	SIGNAL ram_block : RAM;
BEGIN
	
	PROCESS (we, cs, address, data)
	BEGIN
--		IF (we'event AND we = '1') THEN
		IF (we = '0') THEN
			IF (cs = '0') THEN
			    ram_block(to_integer(unsigned(address))) <= data;
			END IF;
		END IF;
	END PROCESS;
	
	PROCESS (cs, ram_block, address)
	BEGIN
		IF (cs = '1') THEN
			q <= "0000000000000000";
		ELSE
			q <= ram_block(to_integer(unsigned(address)));
		END IF;
	END PROCESS;
	
END rtl;
