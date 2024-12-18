library IEEE;
use IEEE.STD_LOGIC_arith.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;
use IEEE.STD_LOGIC_1164.ALL;

entity Tone_generator is
Port ( clk: in STD_LOGIC;
N: in std_logic;
Buzz: out std_logic);
end Tone_generator;

architecture Behavioral of Tone_generator is
signal Q: std_logic_vector(17 downto 0) := "000000000000000000";
signal Sig: std_logic_vector(17 downto 0) := "000000000000000000";
signal EN: std_logic;

begin
Sig <= Q + '1' when Q < "100111000011111111" else "000000000000000000";
Q <= Sig when clk'event and clk='1' and EN= '0';
EN <= '0' when N = '0' else '1';
Buzz<= '1' when (Q < "010011100001111111" and EN = '0') else '0';

end Behavioral;