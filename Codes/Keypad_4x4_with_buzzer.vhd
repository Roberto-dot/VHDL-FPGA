library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Keypad_4x4_with_buzzer is
port(
clk: in std_logic;
Buzz: out std_logic;
salSec: out std_logic_vector(3 downto 0);
input: in STD_logic_vector(3 downto 0));
end Keypad_4x4_with_buzzer;

architecture Behavioral of Keypad_4x4_with_buzzer is
---Sequencer-----
signal Q : STD_LOGIC_VECTOR(1 downto 0) := "00";
signal EN: std_logic;
signal InBuzz : STD_LOGIC_VECTOR(16 downto 0):= "00000000000000000";
signal Sig, actual : STD_LOGIC_VECTOR(17 downto 0) := "000000000000000000";

begin
Q <= Q+'1' when clk'event and clk='1' and EN = '0';
EN <= '0' when input = "0000" else '1';
with Q select
salSec <= "1ZZZ" when "00",
"Z1ZZ" when "01",
"ZZ1Z" when "10",
"ZZZ1" when "11",
"ZZZZ" when others;
InBuzz <= "10111010101000011" when (input = "1000" and Q = "00") else
          "10110000001010010" when (input = "1000" and Q = "01") else
"10100110010001100" when (input = "1000" and Q = "10") else
"10011100111100000" when (input = "1000" and Q = "11") else
"10010100001000011" when (input = "0100" and Q = "00") else
"10001011110100010" when (input = "0100" and Q = "01") else
"10000011111110001" when (input = "0100" and Q = "10") else
"01111100100100000" when (input = "0100" and Q = "11") else
"01110101100100101" when (input = "0010" and Q = "00") else
"01101110111110010" when (input = "0010" and Q = "01") else
"01101000101111110" when (input = "0010" and Q = "10") else
"01100010110111100" when (input = "0010" and Q = "11") else "00000000000000000";
Sig <= actual + '1' when actual < Inbuzz * "10" else "000000000000000000";
actual <= Sig when clk'event and clk='1' and EN= '1';
Buzz<= '1' when (Q < Inbuzz and EN = '1') else '0';
end Behavioral;