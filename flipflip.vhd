-- ------------------------------------
--  7474 Flipflop - onde bit
-- ------------------------------------
--  Author : Lai Aguiar
---------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity flipflip is
    port(
        D       : in std_logic;
        Q       : out std_logic;
        --Q_L     : out std_logic;
        --clear   : in std_logic;
        --set     : in std_logic;
        CLK     : in std_logic
    );
end flipflip;

architecture ffd of flipflip is
    begin
            Q <= D when ((CLK'event) and (CLK = '1'));

            --if (clear = '0') then
                --Q <= '0';
                --Q_L <= '1';

            --else
                --if (set = '0') then
                    --Q <= '1';
                    --Q_L <= '0';

                --else
                    --Q <= D;
                    --Q_L <= not(D);
                --end if;
            --end if;
        end ffd;
