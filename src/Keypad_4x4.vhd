library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_arith.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;

entity Keypad_4x4 is
Port ( clk: in STD_LOGIC;
N: out std_logic;
leds: out STD_logic_vector(3 downto 0);
salidas: out std_logic_vector(3 downto 0);
input: in STD_logic_vector(3 downto 0));
end Keypad_4x4;
architecture Behavioral of Keypad_4x4 is
signal Q: std_logic_vector(1 downto 0):= (others=>'0');
signal EN: std_logic;
begin

Q <= Q + '1' when clk'event and clk='1' and EN = '0';
EN <= '0' when input = "0000" else '1';
N <= EN;

leds <= "0000" when (input = "1000" and Q = "00") else
        "0001" when (input = "1000" and Q = "01") else
        "0010" when (input = "1000" and Q = "10") else
        "0011" when (input = "1000" and Q = "11") else
        "0100" when (input = "0100" and Q = "00") else
        "0101" when (input = "0100" and Q = "01") else
        "0110" when (input = "0100" and Q = "10") else
        "0111" when (input = "0100" and Q = "11") else
        "1000" when (input = "0010" and Q = "00") else
        "1001" when (input = "0010" and Q = "01") else
        "1010" when (input = "0010" and Q = "10") else
        "1011" when (input = "0010" and Q = "11") else
        "1100" when (input = "0001" and Q = "00") else
        "1101" when (input = "0001" and Q = "01") else
        "1110" when (input = "0001" and Q = "10") else
        "1111" when (input = "0001" and Q = "11") else "0000";

 with Q select
salidas <= "1ZZZ" when "00",
"Z1ZZ" when "01",
"ZZ1Z" when "10",
"ZZZ1" when "11",
"ZZZZ" when others;
end Behavioral;