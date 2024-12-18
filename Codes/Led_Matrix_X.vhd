library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Led_Matrix_X is
port(
clk: in std_logic;
CS: out std_logic;
clock: out std_logic;
din: out std_logic;
Boton: in std_logic;
Bot_out: out std_logic
);
end Led_Matrix_X;
architecture Behavioral of Led_Matrix_X is
signal Actual_Data: std_logic_vector(3 downto 0) := "0000";
signal Sig_Data: std_logic_vector(3 downto 0) := "0000";
signal Actual_tiemp: std_logic_vector(4 downto 0) := "00000";
signal Sig_tiemp: std_logic_vector(4 downto 0) := "00000";
signal Actual_5ns: std_logic_vector(3 downto 0) := "0000";
signal Sig_5ns: std_logic_vector(3 downto 0) := "0000";
signal Actual_out: std_logic_vector(3 downto 0) := "0000";
signal Sig_out: std_logic_vector(3 downto 0) := "0000";
signal Qsig: std_logic_vector(15 downto 0):= (others => '0');
signal Qs: std_logic_vector(15 downto 0):= (others => '0');
signal Data: std_logic_vector(15 downto 0) := (others => '0');
signal tiempo: std_logic;
signal inicio: std_logic;
signal LD_sh: std_logic;
signal EN: std_logic;

begin
inicio <= '1' when ((boton = '0' and Actual_tiemp = "00000") or (Actual_Data > "0000" ) or (Actual_tiemp > "00000" )) else '0' ;
Bot_out <= '1' when boton = '1' else '0';
-----Generadora de Datos
--Estado siguiente
Sig_Data <= Actual_Data + '1' when (Actual_Data < X"C")else (others => '0');
--Estado actual
Actual_Data <= sig_Data when (clk'event and clk='1' and inicio = '1' and Sig_tiemp= "00000" and sig_5ns = "0000");
--Logica de salida
--Adress --Configuracion
Data(15 downto 0) <= X"0900" when Actual_Data = X"0" else
X"0A0F" when Actual_Data = X"1" else
X"0B07" when Actual_Data = X"2" else
X"0C01" when Actual_Data = X"3" else
X"0F00" when Actual_Data = X"4" else
--Columnas
X"0181" when Actual_Data = X"5" else
X"0242" when Actual_Data = X"6" else
X"0324" when Actual_Data = X"7" else
X"0418" when Actual_Data = X"8" else
X"0518" when Actual_Data = X"9" else
X"0624" when Actual_Data = X"A" else
X"0742" when Actual_Data = X"B" else
X"0881" when Actual_Data = X"C" else
(others => '0');
--Datos --Configuracion
---Imagen de la matriz
---Columna
--Filas
-----Contador de 19 estados (Para proposito general)
--Estado siguiente
Sig_tiemp <= Actual_tiemp + '1' when Actual_tiemp < "10011" else (others => '0');
--Estado actual
Actual_tiemp <= Sig_tiemp when (clk'event and clk='1' and inicio = '1' and Sig_5ns= "0000");
--Logica de salida
tiempo <= '0' when Actual_tiemp < 4 else '1';
-----Contador de 10 estados
--Estado siguiente
Sig_5ns <= Actual_5ns + '1' when (Actual_5ns < "1001" and tiempo= '1') else (others => '0');
--Estado actual
Actual_5ns <= Sig_5ns when clk'event and clk='1' and tiempo= '1';
--Logica de salida
CS <= '0' when ((inicio ='1' and Actual_tiemp < "10011") or (Actual_tiemp = "10011" and Actual_5ns < "0101")) else '1';
clock<= '1' when (Actual_5ns < "0101" and tiempo= '1') else '0';
Actual_out <= Actual_out + '1' when (Actual_5ns = X"6" and clk'event and clk='1');
EN <= '1' when Actual_5ns = X"6" or Actual_tiemp = "0000" else '0';
LD_SH <= '0' when Actual_tiemp = "0000" else '1';
--Estado siguiente
Qsig <= Data when LD_SH = '0' else
Qs(14 downto 0) & '0';
--Registro
Qs <= Qsig when clk'event and clk='1' and En= '1';
--salida
din <= Qs(15);
end Behavioral;