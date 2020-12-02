-- Unidade de Controle
-- XARA I
-- 20151006
-- 20151028
-- 20151029
-- 20151105 (aqui comeca a ter coerencia)
-- 20151126 (aqui a gente seta os registradores)
-- Importante: a memoria tem 256 enderecos de 16 bits
-- Cada endereco corresponde a um comando que vai ser executado na ALU
-- Cada operacao usa 12 bits, os outros 4 vao ser usados pra setar os registradores

library ieee;
use ieee.std_logic_1164.all;

entity controlunit is
	port (
		 -- entrada memoria, sao os comandos
		 memoria						: in std_logic_vector (15 downto 0);
		 -- selecao da ALU
		 S 								: out std_logic_vector(3 downto 0);
		 -- selecao de valor do cin e de qual registrador ser ausado na ALU
		 CIN, R1, R0 					: out std_logic_vector (1 downto 0);
		 -- sinais de controle do fluxo (esses definem quando as coisas acontecem)
		 grava, clear_4regs 			: out std_logic;
		 decoder_en, neg_clear_counter 	: out std_logic;
		 count_en, load_reg_saida 		: out std_logic;
		 -- sinais de selecao de qual registrador recebe a saida da ALU (sao sinais de selecao de um decodificador)
		 R20, R21 						: out std_logic;
		 CLOCK 							: in std_logic;
		 CLEAR 							: in std_logic;
		 -- me diz se eu gravo ou leio a memoria
		 Modo_memoria 					: in std_logic
	);
end controlunit;

architecture control_u of controlunit is

begin

	process(CLOCK)
	
	variable estado : integer := 0;
	variable prox_estado : integer := 0;
	
	begin
		
		if (modo_memoria = '1') then
				grava <= '1';
				clear_4regs <= '0';
				decoder_en <= '0';
				neg_clear_counter <= '1';
				count_en <= '1';
				load_reg_saida <= '0';
			end if;
			
		if (modo_memoria = '0') then

			if (CLOCK'event and CLOCK = '1') then
			
				if (CLEAR = '1') then
					-- clear tudo que tem nos registradores,
					-- nao apaga a memoria de programa
					grava <= '0';
					clear_4regs <= '1';
					decoder_en <= '0';
					neg_clear_counter <= '0';
					count_en <= '0';
					load_reg_saida <= '0';
					
				end if;
				
				if (CLEAR = '0') then
				
					-- Fazer a parte de ler o que esta no programa pra setar os registradores(4)
					-- Precisa de pelo menos 8 (provavelmente mais) ciclos pra setar tudo, pra garantir que leu direito
					--
					--
					--
					--
					--
					--
					--
					
				
					--leitura do comando que tah gravado na memoria
		
					-- 1 bit
					R20 <= memoria(1);
					R21 <= memoria(0);
					
					-- 2 bits
					CIN <= memoria(7 downto 6);
					R1 <= memoria(3 downto 2);
					R0 <= memoria(5 downto 4);
					
					-- 4 bits
					S <= memoria(8 to 11);
					
					if (estado = 0) then
					
						-- controle do fluxo
						grava <= '0';
						clear_4regs <= '0';
						decoder_en <= '0';
						neg_clear_counter <= '1';
						count_en <= '0';
						load_reg_saida <= '0';
						
						prox_estado := 1;
						
					end if;
					
					if (estado = 1) then
			
						-- controle do fluxo
						grava <= '0';
						clear_4regs <= '0';
						decoder_en <= '0';
						neg_clear_counter <= '1';
						count_en <= '0';
						load_reg_saida <= '1';
						
						prox_estado := 2;
						
					end if;
					
					if (estado = 2) then
						
						-- controle do fluxo
						grava <= '0';
						clear_4regs <= '0';
						decoder_en <= '1';
						neg_clear_counter <= '1';
						count_en <= '0';
						load_reg_saida <= '0';
						
						prox_estado := 3;
						
					end if;
					
					if (estado = 3) then
						
						-- controle do fluxo
						grava <= '0';
						clear_4regs <= '0';
						decoder_en <= '0';
						neg_clear_counter <= '1';
						count_en <= '1';
						load_reg_saida <= '0';
						
						prox_estado := 0;
						
					end if;

					estado := prox_estado;

				end if;
			end if;
		end if;
		
	end process;
	
end control_u;