-- Multiplexador 8X4
-- 1 bit de selecao
-- XARA I
-- 20151028

library ieee;
use ieee.std_logic_1164.all;

entity mux4x1 is
	port (
		 I0, I1, I2, I3 	: in std_logic;
		 Q 					: out std_logic;
		 sel 				: in std_logic_vector (1 downto 0)
	);
end mux4x1;

architecture mux of mux4x1 is
begin
	Q <= I0 when Sel = "00";
	Q <= I1 when Sel = "01";
	Q <= I2 when Sel = "10";
	Q <= I3 when Sel = "11";
end mux;
