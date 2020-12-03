-- ------------------------------------
--  4 bit Register
-- ------------------------------------
--  Author : Lai Aguiar
---------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity reg4 is port (
	PIN 			: in std_logic_vector(3 downto 0);
	LOA, CLR, CLK 	: in std_logic;
	POUT 			: out std_logic_vector(3 downto 0)
	);
end reg4;

architecture r4 of reg4 is
begin
	process (CLK)
	begin
		if (CLK = '1' and CLK'event) then
			if (LOA = '1') then
				POUT <= PIN;
			end if;
			if (CLR = '1') then
				POUT <= "0000";
			end if;
		end if;
	end process;
end r4;