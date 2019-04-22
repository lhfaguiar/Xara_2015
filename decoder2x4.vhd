-- decoder 2x4
-- Xara I
-- 20151208

library ieee;
use ieee.std_logic_1164.all;

entity decoder2x4 is
    port(
        Sel     : in std_logic_vector(1 downto 0);
        Output  : out std_logic_vector (3 downto 0)
    );
end decoder2x4;

architecture arch of decoder2x4 is
    begin
        Output <= "0111" when Sel = "00";
        Output <= "1011" when Sel = "01";
        Output <= "1101" when Sel = "10";
        Output <= "1110" when Sel = "11";
end arch;
