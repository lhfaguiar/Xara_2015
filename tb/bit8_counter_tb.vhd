-- Contador de 8 bits
-- XARA I
-- 20151207
-- 20151215
-- 20151221
--testbench

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity bit8_counter_tb is
end bit8_counter_tb;

architecture behav of bit8_counter_tb is

	component bit8_counter is
	port (
		CLK : in std_logic;
		Reset : in std_logic;
		Enable : in std_logic;
		Q : out std_logic_vector (7 downto 0)
	);
	end component;

	signal clock 		: std_logic := '0';
	signal reset 		: std_logic := '0';
	signal enable 		: std_logic := '1';
	signal output 		: std_logic_vector (7 downto 0);
	constant periodo 	: time := 10 ns;
	shared variable	fim	: boolean := false;

begin

	UUT : bit8_counter
	port map (
		CLK 	=> clock,
		Reset 	=> reset,
		Enable 	=> enable,
		Q 		=> output
	);

	CLK : process
	begin
		if (fim = false) then
			clock <= '1' after 5 ns;
			clock <= '0' after 5 ns;
		else wait;
		end if;
	end process;

	stim : process
	begin
		enable <= '0';
		wait for 40 ns;
		enable <= '1';
		reset <= '0';
		wait for 500 ns;
		reset <= '1';
		fim := true;

		report "terminou teste bench";
	end process;



end behav;
