library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Keypad_4x4_with_buzzer is
    port(
        clk: in std_logic; -- Clock signal input
        Buzzer: out std_logic; -- Buzzer output
        Seq_Out: out std_logic_vector(3 downto 0); -- Rows of the keypad (sequence output)
        Input: in STD_logic_vector(3 downto 0) -- Columns of the keypad (key input)
    );
end Keypad_4x4_with_buzzer;

architecture Behavioral of Keypad_4x4_with_buzzer is
    -- Signals for state tracking
    signal Counter: std_logic_vector(1 downto 0) := "00"; -- 2-bit counter for keypad scanning
    signal En: std_logic; -- Enable signal
    signal Tone_threshold: std_logic_vector(16 downto 0) := (others => '0'); -- Tone threshold for buzzer
    signal Next_State: std_logic_vector(17 downto 0) := (others => '0'); -- Next state for tone generator counter
    signal Current_State: std_logic_vector(17 downto 0) := (others => '0'); -- Current state of tone generator counter
begin
    -- Counter logic: Increment the counter on clock rising edge when enabled
    Counter <= Counter + '1' when clk'event and clk = '1' and En = '0';

    -- Enable signal logic: Enable is '0' when no key is pressed, otherwise '1'
    En <= '0' when Input = "0000" else '1';

    -- Sequence output logic based on the counter
    with Counter select
        Seq_Out <= "1ZZZ" when "00", -- Activate row 0
                   "Z1ZZ" when "01", -- Activate row 1
                   "ZZ1Z" when "10", -- Activate row 2
                   "ZZZ1" when "11", -- Activate row 3
                   "ZZZZ" when others; -- Default to no activation

    -- Tone threshold logic: Determines the tone threshold for the buzzer based on the pressed key and row
    Tone_threshold <= "10111010101000011" when (Input = "1000" and Counter = "00") else
                      "10110000001010010" when (Input = "1000" and Counter = "01") else
                      "10100110010001100" when (Input = "1000" and Counter = "10") else
                      "10011100111100000" when (Input = "1000" and Counter = "11") else
                      "10010100001000011" when (Input = "0100" and Counter = "00") else
                      "10001011110100010" when (Input = "0100" and Counter = "01") else
                      "10000011111110001" when (Input = "0100" and Counter = "10") else
                      "01111100100100000" when (Input = "0100" and Counter = "11") else
                      "01110101100100101" when (Input = "0010" and Counter = "00") else
                      "01101110111110010" when (Input = "0010" and Counter = "01") else
                      "01101000101111110" when (Input = "0010" and Counter = "10") else
                      "01100010110111100" when (Input = "0010" and Counter = "11") else
                      (others => '0'); -- Default to 0 when no valid key is pressed

    -- Tone generator logic: Increment the counter until the tone threshold is reached
    Next_State <= Current_State + '1' when Current_State < Tone_threshold * "10" else (others => '0');

    -- Update the tone generator counter on clock rising edge when enabled
    Current_State <= Next_State when clk'event and clk = '1' and En = '1';

    -- Buzzer output logic: Activates the buzzer when the counter is below the threshold and enabled
    Buzzer <= '1' when (Counter < Tone_threshold and En = '1') else '0';
end Behavioral;
