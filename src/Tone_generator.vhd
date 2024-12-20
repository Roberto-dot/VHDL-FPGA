library IEEE;
use IEEE.STD_LOGIC_arith.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;
use IEEE.STD_LOGIC_1164.ALL;


entity Tone_generator is
    Port (
        clk : in STD_LOGIC; -- Clock signal input
        N : in std_logic; -- Enable input
        Buzzer : out std_logic -- Buzzer output
    );
end Tone_generator;


architecture Behavioral of Tone_generator is
    -- Signals for state tracking
    signal Current_counter : std_logic_vector(17 downto 0) := (others => '0'); -- 18-bit counter
    signal next_counter : std_logic_vector(17 downto 0) := (others => '0'); -- 18-bit next state for the counter
    signal En : std_logic; -- Internal enable signal
begin
    -- Counter increment logic: Increment the counter until a maximum value is reached
    next_counter <= Current_counter + '1' when Current_counter < "100111000011111111" else (others => '0');

    -- Counter update logic: Update the counter on clock rising edge when enabled
    Current_counter <= next_counter when clk'event and clk = '1' and En = '0';

    -- Enable signal logic: Enable is '0' when input enable is '0', otherwise '1'
    En <= '0' when N = '0' else '1';

    -- Buzzer output logic: Activate the Buzzer when the counter is below a threshold and enabled
    Buzzer <= '1' when (Current_counter < "010011100001111111" and En = '0') else '0';

end Behavioral;