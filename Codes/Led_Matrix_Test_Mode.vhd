library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Led_Matrix_Test_Mode is
port(
clk: in std_logic;
CS: out std_logic;
clock: out std_logic;
din: out std_logic;
Boton: in std_logic);
end Led_Matrix_Test_Mode;

architecture Behavioral of Led_Matrix_Test_Mode is
signal Actual_tiemp: std_logic_vector(4 downto 0) := "00000";
signal Sig_tiemp: std_logic_vector(4 downto 0) := "00000";
signal Actual_out: std_logic_vector(3 downto 0) := "0000";
signal Sig_out: std_logic_vector(3 downto 0) := "0000";
signal tiempo: std_logic;
signal inicio: std_logic;
signal EN: std_logic;

begin
inicio <= '1' when ((boton = '0' and Actual_tiemp = "00000") or (Actual_tiemp > "00000" and Actual_tiemp < "10100")) else '0' ;
Sig_tiemp <= Actual_tiemp + '1' when Actual_tiemp < "10011" else "00000";
Actual_tiemp <= Sig_tiemp when (clk'event and clk='1' and inicio = '1' and Sig_out= "0000");
CS <= '0' when ((inicio ='1' and Actual_tiemp < "10011") or (Actual_tiemp = "10011" and Actual_out < "0101")) else '1';
with Actual_Tiemp select
tiempo<= '0' when "00000",
         '0' when "00001",
         '0' when "00010",
         '0' when "00011",
         '1' when others;
Sig_out <= Actual_out + '1' when (Actual_out < "1001" and tiempo= '1')else "0000";
Actual_out <= Sig_out when clk'event and clk='1' and tiempo= '1';
clock<= '1' when (Actual_out < "0101" and tiempo= '1') else '0';
Din<= '1';

end Behavioral;