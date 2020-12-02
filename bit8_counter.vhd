-- Contador de 8 bits
-- XARA I

-- nao esquecer que tem que usar a biblioteca synopsys pra compilar

-- 20151207

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity bit8_counter is
	port (
		 CLK 		: in std_logic;
		 Reset 		: in std_logic;
		 Enable 	: in std_logic;
		 Q 			: out std_logic_vector(7 downto 0)
	);
end bit8_counter;

architecture arch of bit8_counter is
	signal temp: std_logic_vector(7 downto 0);
begin
	process(CLK,Reset)
	begin
		if Reset='1' then
			temp <= "00000000";
	elsif(rising_edge(CLK)) then
		if (Enable = '1') then
			if ieee.std_logic_1164."="(temp,"11111111") then
				temp<="00000000";
	    else
			temp <= temp + 1;
			end if;
		end if;
      end if;
   end process;
   Q <= temp;
end arch;
