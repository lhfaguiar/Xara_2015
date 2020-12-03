-- ------------------------------------
--  4 bit Register
-- ------------------------------------
--  Author : Lai Aguiar
---------------------------------------


library ieee;
use ieee.std_logic_1164.all;

entity REG4_EN is port (
	PIN 					: in std_logic_vector(3 downto 0);
	LOA, CLR, CLK, EN 		: in std_logic;
	POUT 					: out std_logic_vector(3 downto 0)
	);
end REG4_EN;

architecture R4 of REG4_EN is
begin
	process (CLK)
	begin
		if (EN = '0') then
			if (CLK = '1' and CLK'event) then
				if (LOA = '1') then
					POUT <= PIN;
				end if;
				if (CLR = '1') then
					POUT <= "0000";
				end if;
			end if;
		end if;
	end process;
end R4;
