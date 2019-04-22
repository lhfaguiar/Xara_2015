-- Multiplexador 8X4
-- 1 bit de selecao
-- XARA I
-- 20151028
-- 20151217

library ieee;
use ieee.std_logic_1164.all;

entity mux8x4 is
	port (
		 I1, I0 		: in std_logic_vector (3 downto 0);
		 Q 				: out std_logic_vector(3 downto 0);
		 sel	 		: in std_logic
	);
end mux8x4;

architecture mux of mux8x4 is
begin
	Q <= I0 when sel = '0';
	Q <= I1 when sel = '1';
end mux;
