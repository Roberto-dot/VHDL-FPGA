library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Lucy_Song_Buzzer is
port(
clk: in std_logic;
Buzz: out std_logic);
end Lucy_Song_Buzzer;
architecture Behavioral of Lucy_Song_Buzzer is
--Señales---
signal Q : STD_LOGIC_VECTOR(4 downto 0) := "00000";
signal Sig_buzz, actual_buzz : STD_LOGIC_VECTOR(18 downto 0) := "0000000000000000000";
signal Sig_cont, actual_cont : STD_LOGIC_VECTOR(25 downto 0) := "00000000000000000000000000";
signal EN: std_logic;
signal Lucy :STD_LOGIC_VECTOR(17 downto 0) := "000000000000000000";
signal ya: std_logic;
signal sil: std_logic;
begin
--- Ciclo principal --
Q <= Q+'1' when clk'event and clk='1' and ya = '1';
with Q select
Lucy <= "010010100001000011" when "00000", --E4--
        "010010100001000011" when "00001", --E4--
        "001101110111110010" when "00010", --A4--
        "001101110111110010" when "00011", --A4--
        "110010100001000011" when "00100", --E5--
        "110010100001000011" when "00101", --E5--
"001111100100100000" when "00110", --G4--
"001111100100100000" when "00111", --G4--
"110010100001000011" when "01000", --E5--
"110010100001000011" when "01001", --E5--
"001101110111110010" when "01010", --A4--
"001101110111110010" when "01011", --A4--
"010000011111110001" when "01100", --Fsos4--
"010000011111110001" when "01101", --Fsos4--
"001101110111110010" when "01110", --A4--
"001101110111110010" when "01111", --A4--
"110010100001000011" when "10000", --E5--
"110010100001000011" when "10001", --E5--
"001111100100100000" when "10010", --G4--
"001111100100100000" when "10011", --G4--
"110100110010001100" when "10100", --D5--
"110110000001010010" when "10101", --Csos5--
"001101110111110010" when "10110", --A4--
"001101110111110010" when "10111", --A4--
"000000000000000000" when others;
sil <= '0';
--Contador para el tiempo--
Sig_cont <= actual_cont + '1' when actual_cont < "10001111000011010001100000" else "00000000000000000000000000"; --Tiempo-- --"10001111000011010001100000"
actual_cont <= Sig_cont when clk'event and clk='1';
ya <= '1' when actual_cont > "10001111000011010001011111" else '0'; --"10001111000011010001011111"
EN <= '1' when sil = '1' else '0';
--Buzzer--
Sig_buzz <= actual_buzz + '1' when actual_buzz < Lucy * "10" else "0000000000000000000";
actual_buzz <= Sig_buzz when clk'event and clk='1' and EN= '0';
Buzz<= '1' when (actual_buzz < Lucy and EN = '0') else '0';
end Behavioral;