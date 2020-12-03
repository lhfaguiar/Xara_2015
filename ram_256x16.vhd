-- ------------------------------------
--  256x16 Random Access Memory
-- ------------------------------------
--  Author : Lai Aguiar
---------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ram_256x16 is
	port
	(
		data			: in  std_logic_vector(15 downto 0);
		address			: in  std_logic_vector(7 downto 0);
		we				: in  std_logic;
		cs				: in  std_logic;
		q				: out std_logic_vector(15 downto 0)
	);
end ram_256x16;

architecture rtl of ram_256x16 IS
	type RAM is array(0 to 256) of std_logic_vector(15 downto 0);

	signal ram_block : RAM;
begin
	
	process (we, cs, address, data)
	begin
--		if (we'event and we = '1') then
		if (we = '0') then
			if (cs = '0') then
			    ram_block(to_integer(unsigned(address))) <= data;
			end if;
		end if;
	end process;
	
	process (cs, ram_block, address)
	begin
		if (cs = '1') then
		    q <= "0000000000000000";
		else
			q <= ram_block(to_integer(unsigned(address)));
		end if;
	end process;
	
end rtl;
