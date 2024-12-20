library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_arith.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;

entity Keypad_4x4 is
    Port ( clk: in STD_LOGIC; -- Clock signal input
        N: out std_logic; -- Enable output
        Leds: out STD_logic_vector(3 downto 0); -- LED output
        Seq_Out: out std_logic_vector(3 downto 0); -- Sequence output (Columns Keypad)
        Input: in STD_logic_vector(3 downto 0)); -- Input keypad (Rows Keypad)
end Keypad_4x4;

architecture Behavioral of Keypad_4x4 is
    -- Signals for state tracking
    signal Counter: std_logic_vector(1 downto 0):= "00"; -- 2-bit counte
    signal En: std_logic; --Enable signal 
begin
    -- Counter logic: Increment the counter on clock rising edge when enabled
    Counter <= Counter + '1' when clk'event and clk ='1' and En = '0';

    -- Enable signal logic
    En <= '0' when Input = "0000" else '1';
    N <= En;

    -- LED output logic based on keypad input and counter state
    Leds <= "0000" when (Input = "1000" and Counter = "00") else
            "0001" when (Input = "1000" and Counter = "01") else
            "0010" when (Input = "1000" and Counter = "10") else
            "0011" when (Input = "1000" and Counter = "11") else
            "0100" when (Input = "0100" and Counter = "00") else
            "0101" when (Input = "0100" and Counter = "01") else
            "0110" when (Input = "0100" and Counter = "10") else
            "0111" when (Input = "0100" and Counter = "11") else
            "1000" when (Input = "0010" and Counter = "00") else
            "1001" when (Input = "0010" and Counter = "01") else
            "1010" when (Input = "0010" and Counter = "10") else
            "1011" when (Input = "0010" and Counter = "11") else
            "1100" when (Input = "0001" and Counter = "00") else
            "1101" when (Input = "0001" and Counter = "01") else
            "1110" when (Input = "0001" and Counter = "10") else
            "1111" when (Input = "0001" and Counter = "11") else "0000";

    -- Sequence output logic based on counter state
     with Counter select
        Seq_Out <= "1ZZZ" when "00",
                   "Z1ZZ" when "01",
                   "ZZ1Z" when "10",
                   "ZZZ1" when "11",
                   "ZZZZ" when others;

end Behavioral;
