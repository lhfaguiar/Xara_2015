-- ------------------------------------
--  4 bit NOT bus
-- ------------------------------------
--  Author : Lai Aguiar
---------------------------------------


library ieee;
use ieee.std_logic_1164.all;

entity NOT_bus is
	port (
		 Input    : in  std_logic_vector (3 downto 0);
		 Q        : out std_logic_vector(3 downto 0)
	);
end NOT_bus;

architecture N_bus of NOT_bus is
begin
    Q <= not (Input);
end N_bus;
