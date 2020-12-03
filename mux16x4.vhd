-- ------------------------------------
--  16x4 Multiplexer
-- ------------------------------------
--  Author : Lai Aguiar
---------------------------------------


-- Multiplexador 16X4
-- 2 bit de selecao
-- XARA I
-- 20151028

library ieee;
use ieee.std_logic_1164.all;

entity mux16x4 is
	port (
		 I0, I1, I2, I3 		: in std_logic_vector (3 downto 0);
		 Q 						: out std_logic_vector(3 downto 0);
		 sel 					: in std_logic_vector (1 downto 0)
	);
end mux16x4;

architecture mux of mux16x4 is
begin
	Q <= I0 when sel = "00";
	Q <= I1 when sel = "01";
	Q <= I2 when sel = "10";
	Q <= I3 when sel  = "11";

	--if (sel = "00") then
	--	Q <= I0;
	--end if;

	--if (sel ="01") then
	--	Q <= I1;
	--end if;

	--if (sel = "10") then
	--	Q <= I2;
	--end if;

	--if (sel = "11") then
	--	Q <= I3;
	--end if;
end mux;
