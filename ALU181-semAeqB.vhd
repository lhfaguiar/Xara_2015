-- Il sistema viene testato solo per ingressi veri positivi
-- (Mode=1 e Mode=0 con Carry IN=1)


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_signed.all;
--use IEEE.numeric_std.all;


entity ALU181 is
    Port ( A                     : in      STD_LOGIC_VECTOR (3 downto 0);
           B                     : in      STD_LOGIC_VECTOR (3 downto 0);
           S                     : in      STD_LOGIC_VECTOR (3 downto 0);
           Mode                  : in      STD_LOGIC;
           Carry_In              : in      STD_LOGIC;
           Output                : inout STD_LOGIC_VECTOR (3 downto 0);
           Carry_Generate        : inout STD_LOGIC;
           Carry_Propagate       : inout STD_LOGIC;
           Carry_Out             : out      STD_LOGIC);
end ALU181;


architecture Behavioral of ALU181 is

    signal Nor_Vector         : STD_LOGIC_VECTOR (8 downto 1);
    signal auxiliar           : std_logic_vector (3 downto 0);

begin

--    auxiliar <= unsigned(A) - unsigned(B) - 1;

-- NB tutti gli operandi sono considerati in logica positiva

-- Sintesi strutturale
    Nor_Vector(1) <= not((B(3)and S(3)and A(3))or(S(3)and S(2)and not B(3)));
    Nor_Vector(3) <= not((B(2)and S(3)and A(2))or(A(2)and S(2)and not B(2)));
    Nor_Vector(5) <= not((B(1)and S(3)and A(1))or(A(1)and S(2)and not B(1)));
    Nor_Vector(7) <= not((B(0)and S(3)and A(0))or(A(0)and S(2)and not B(0)));

    Nor_Vector(2) <= not((not B(3)and S(1))or(S(1)and B(3))or A(3));
    Nor_Vector(4) <= not((not B(2)and S(1))or(S(0)and B(2))or A(2));
    Nor_Vector(6) <= not((not B(1)and S(1))or(S(0)and B(1))or A(1));
    Nor_Vector(8) <= not((not B(0)and S(1))or(S(0)and B(0))or A(0));

    Carry_Generate     <= not(
                                   Nor_Vector(2)                                                         or
                                  (Nor_Vector(1) and Nor_Vector(4))                                      or
                                  (Nor_Vector(1) and Nor_Vector(3) and Nor_Vector(6))                    or
                                  (Nor_Vector(1) and Nor_Vector(3) and Nor_Vector(5)and Nor_Vector(8))
                                    );
    Carry_Propagate     <= not(Nor_Vector(1) and Nor_Vector(3) and Nor_Vector(5) and Nor_Vector(7));

    Carry_Out             <= not(
                             Carry_Generate and
                             not(Nor_Vector(1) and Nor_Vector(3) and Nor_Vector(5) and Nor_Vector(7)and Carry_In)
                                     );


    processo: process(A, B, S, Mode, Carry_In)

    begin

-- Sintesi funzionale

                if (Mode = '1')  then

                Case S is

                when "0000" => Output <= not(A);
                when "0001" => Output <= not(A or B);
                when "0010" => Output <= not(A) and (B);
                when "0011" => Output <= "0000";
                when "0100" => Output <= not(A and B);
                when "0101" => Output <= not(B);
                when "0110" => Output <= (A) xor (B);
                when "0111" => Output <= A and not(B);
                when "1000" => Output <= not(A) or B;
                when "1001" => Output <= not (A xor B);
                when "1010" => Output <= B;
                when "1011" => Output <= A and B;
                when "1100" => Output <= "1111";
                when "1101" => Output <= A or not(B);
                when "1110" => Output <= A or B;
                when "1111" => Output <= A;
                when others => null;

                end case
                ;

                elsif (Mode = '0') and (Carry_In = '1')then

                Case S is

                when "0000" => Output <= A;
                when "0001" => Output <= A or B;
                when "0010" => Output <= A or not(B);
                when "0011" => Output <= "1111";
                when "0100" => Output <= A +(A and not(B));
                when "0101" => Output <= (A or B)+(A and not(B));
                when "0110" => Output <= A - B -1;
                when "0111" => Output <= (A and not(B)) - 1 ;
                when "1000" => Output <= A + (A and B);
                when "1001" => Output <= A + B;
                when "1010" => Output <= (A or not(B)) + (A and B);
                when "1011" => Output <= (A and B) - 1 ;
                when "1100" => Output <= A + A;
                when "1101" => Output <= (A or B) + A;
                when "1110" => Output <= (A or not(B)) + A;
                when "1111" => Output <= A - 1;
                when others => null;

                end case
                ;

        elsif (Mode = '0') and (Carry_In = '0') then

                Case S is

                when "0000" => Output <= A + 1;
                when "0001" => Output <= (A or B) + 1;
                when "0010" => Output <= (A or not(B)) + 1;
                when "0011" => Output <= "0000";
                when "0100" => Output <= (A +(A and not(B))) +1;
                when "0101" => Output <= (A or B)+(A and not(B)) +1;
                when "0110" => Output <= A - B;
                when "0111" => Output <= A and not(B);
                when "1000" => Output <= A + (A and B) + 1;
                when "1001" => Output <= A + B + 1;
                when "1010" => Output <= (A or not(B)) + (A and B) +1;
                when "1011" => Output <= A and B;
                when "1100" => Output <= A + A + 1;
                when "1101" => Output <= (A or B) + A + 1;
                when "1110" => Output <= (A or not(B)) + A + 1;
                when "1111" => Output <= A;
                when others => null;

                end case
                ;
    end if;

-- NB Qui, a differenza dello schematico, A equal B è settato solo nel caso della
-- situazione significativa



    end process processo;

end Behavioral;
