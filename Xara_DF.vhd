-- 20151208
-- comeca a fazer o data flow em vhdl
-- 20151209
-- coloca controlunit e reorganiza os signals

-- pergunta: coloca a CU aqui como componente?!
-- resposta: pode sim, nao tem uma regra, pode organizar como quiser desde que seja bem documentado e explicado.


-- ------------------------------------
--  Xara Dataflow
-- ------------------------------------
--  Author : Lai Aguiar
---------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity data_flow is
    port (

        -- input da memoria
        --(como vou salvar o programa na memoria?)     ATENCAO: TENTA RESOLVER ISSO: pode ser usar um microcontrolador com um programinha que faca isso
        progr : in std_logic_vector (15 downto 0);

        -- saida memoria, sao os comandos
        memoria : out std_logic_vector (15 downto 0);

        -- selecao da ALU
        S : in std_logic_vector(3 downto 0);

        -- selecao de valor do cin e de quaos registradores serao ausados na ALU
        CIN, R1, R0 : in std_logic_vector (1 downto 0);

        -- sinais de controle do fluxo (esses definem quando as coisas acontecem)
        grava, clear_4regs, decoder_en, neg_clear_counter : in std_logic;
        count_en, load_reg_saida : in std_logic;

        -- sinais de selecao de qual registrador recebe a saida da ALU
        -- (sao sinais de selecao de um decodificador)
        R20, R21 : in std_logic;

        -- sinais globais
        CLOCK : in std_logic;
        CLEAR : in std_logic;


        -- sinais externos
        -- os sinais que sao in std_logic sao chaves,
        -- os outros sao saidas pra unidade de controle
        modo_memoria : in std_logic;
        modo_mem : out std_logic;
        limpa : in std_logic;
        limpa_s : out std_logic

    );

end data_flow;

architecture data_arch of data_flow is

    modo_mem <= modo_memoria;
    limpa_s <= limpa;

    -- listagem de todos os diferentes tipos de componentes
    -- que sao usados no data flow do Xara I

    -- registradores de 4 bits
    component reg4
    -- atencao que o enbale eh ativo baixo
        port(
            PIN                 : in  std_logic_vector(3 downto 0);
            LOA, CLR, CLK       : in  std_logic;
            POUT                : out std_logic_vector(3 downto 0)
        );
    end component;

    -- contador de 8 bits
    component bit8_counter
        port (
             CLK                : in  std_logic;
             Reset              : in  std_logic;
             Enable             : in  std_logic;
             Q                  : out std_logic_vector(7 downto 0)
        );
    end component;

    -- mux 4x1
    component mux4x1
        port(
            I0, I1, I2, I3      : in  std_logic;
            Q                   : out std_logic;
            sel                 : in  std_logic_vector (1 downto 0)
        );
    end component;

    -- mux 8x4
    component mux8x4
        port(
            I1, I0              : in  std_logic_vector (3 downto 0);
            Q                   : out std_logic_vector(3 downto 0);
            sel                 : in  std_logic
            );
    end component;

    -- mux 16x4
    component mux16x4
        port (
             I0, I1, I2, I3     : in  std_logic_vector (3 downto 0);
             Q                  : out std_logic_vector(3 downto 0);
             sel                : in  std_logic_vector (1 downto 0)
        );
    end component;

    -- NOT_bus
    component NOT_bus
        port (
             IN                 : in  std_logic_vector (3 downto 0);
             Q                  : out std_logic_vector(3 downto 0)
        );
    end component;

    -- memoria
    component ram_256x16
        port(
            data                : in  std_logic_vector(15 DOWNTO 0);
            address             : in  std_logic_vector(7 DOWNTO 0);
            we                  : in  std_logic;
            cs                  : in  std_logic;
            q                   : out std_logic_vector(15 DOWNTO 0)
        );
    end component;

    -- flipflop
    component flipflip
        port(
            D                   : in  std_logic;
            Q                   : out std_logic;
            --Q_L               : out std_logic;
            clear               : in  std_logic;
            set                 : in  std_logic;
            CLK                 : in  std_logic
        );
    end component;
    -- no flipflip atencao que set e clear sao ativo baixo

    -- ALU181 (74181)
    component ALU181
        port(
            A                   : in      STD_LOGIC_VECTOR (3 downto 0);
            B                   : in      STD_LOGIC_VECTOR (3 downto 0);
            S                   : in      STD_LOGIC_VECTOR (3 downto 0);
            Mode                : in      STD_LOGIC;
            Carry_In            : in      STD_LOGIC;
            Output              : inout STD_LOGIC_VECTOR (3 downto 0);
            AeqB                : out      STD_LOGIC;
            Carry_Generate      : inout STD_LOGIC;
            Carry_Propagate     : inout STD_LOGIC;
            Carry_Out           : out      STD_LOGIC
        );
    end component;

    -- decoder
    component decoder2x4
        port(
            sel                 : in std_logic;
            OUT                 : out std_logic
        );
    end component;


    -- sinais (fios)
    signal Cin, I2, ALUCin          : std_logic;
    signal PIN, ALUQ                : std_logic_vector (3 downto 0);
    signal Q0, Q1, Q1, Q3           : std_logic_vector (3 downto 0);
    signal A, B                     : std_logic_vector (3 downto 0);
    signal sel_decoder              : std_logic_vector (1 downto 0);
    signal Addr_mem                 : std_logic_vector (7 downto 0);
    signal D                        : std_logic_vector (3 downto 0);


begin
    -- declaracao de cada componente que constitui o DF

    sel_decoder(0) <= R20;
    sel_decoder(1) <= R21;

    -- flipflip de Cin
    FFD : flipflip
        portmap (
            D                   => Cin,
            Q                   => I2,
            --Q_L               => I3,
            CLK                 => CLOCK
        );

    -- Registrador 0
    R0 : reg4
        portmap (
            PIN                 => PIN,
            LOA                 => D(0),
            CLR                 => clear_4regs,
            CLK                 => CLOCK,
            POUT                => Q0
        );

    -- Registrador 1
    R1 : reg4
        portmap (
            PIN                 => PIN,
            LOA                 => D(1),
            CLR                 => clear_4regs,
            CLK                 => CLOCK,
            POUT                => Q1
        );

    -- Registrador 2
    R2 : reg4
        portmap (
            PIN                 => PIN,
            LOA                 => D(2),
            CLR                 => clear_4regs,
            CLK                 => CLOCK,
            POUT                => Q2
        );

    -- Registrador 3
    R3 : reg4
        portmap (
            PIN                 => PIN,
            LOA                 => D(3),
            CLR                 => clear_4regs,
            CLK                 => CLOCK,
            POUT                => Q3
        );

    -- Memoria de programa
    MEM : ram_256x16
        portmap (
            data                => progr,
            address             => Addr_mem,
            we                  => grava,
            cs                  => '0',
            q                   => memoria
        );

    -- contador de 8 bits (ele carre a memoria)
    contador : bit8_counter
        portmap (
            CLK                 => CLOCK,
            Reset               => neg_clear_counter,
            Enable              => count_en,
            Q                   => Addr_mem
        );

    -- mux que seleciona o primeiro Reg da operacao
    mux0 : mux16x4
        portmap (
            I0                  => Q0,
            I1                  => Q1,
            I2                  => Q2,
            I3                  => Q3,
            Q                   => A,
            sel                 => R0
        );

    -- mux que seleciona o segundo Reg da operacao
    mux1 : mux16x4
        portmap (
            I0                  => Q0,
            I1                  => Q1,
            I2                  => Q2,
            I3                  => Q3,
            Q                   => B,
            sel                 => R1
        );

    -- mux que seleciona o CIN se existe ou se é fixo,
    -- ou se depende de operacao anterior
    muxFFD : mux4x1
        portmap (
            I0                  => '0',
            I1                  => '1',
            I2                  => I2,
            I3                  => not (I2),
            Q                   => ALUCin,
            sel                 => CIN
        );

    -- registrador de saida
    Reg4 : reg4
        portmap (
            PIN                 => ALUQ,
            LOA                 => load_reg_saida,
            CLR                 => CLEAR,
            CLK                 => CLOCK,
            POUT                => PIN
        );

    -- ALU181
    ALU : ALU181
        portmap (
            A                   => A,
            B                   => B,
            S                   => S,
            Mode                => '0',
            Carry_In            => ALUCin,
            Output              => ALUQ,
            AeqB                =>
            Carry_Generate      =>
            Carry_Propagate     =>
            Carry_Out           => Cin
        );

    -- decoder 2x4
    decoder : decoder2x4
        portmap (
            sel                 => sel_decoder,
            OUT                 => D
        );


end data_arch;
