-- This code is designed to operate in test mode for the LED matrix with a 100 MHz clock
-- Compatible with the MAX752 device for testing purposes only

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Led_Matrix_Test_Mode is
port(
    clk: in std_logic;        -- Clock signal
    CS: out std_logic;        -- Chip Select signal
    clock: out std_logic;     -- Clock output for LED matrix
    din: out std_logic;       -- Data input for LED matrix
    Button: in std_logic       -- Button input for test mode control
);
end Led_Matrix_Test_Mode;

architecture Behavioral of Led_Matrix_Test_Mode is
    -- Signals for time and output state tracking
    signal Current_time: std_logic_vector(4 downto 0) := "00000";  -- Current state of the 19-state counter
    signal Next_time: std_logic_vector(4 downto 0) := "00000";     -- Next state of the 19-state counter
    signal Current_out: std_logic_vector(3 downto 0) := "0000";     -- Current output state for LED control
    signal Next_out: std_logic_vector(3 downto 0) := "0000";        -- Next output state for LED control
    signal Tim: std_logic;    -- Timing signal for output control
    signal Start: std_logic;    -- Start signal to control test mode operation
    signal EN: std_logic;        -- Enable signal for output operation

begin
    -- Start signal logic: initializes the system when the button is pressed and time counter is within a range
    Start <= '1' when ((Button = '0' and Current_time = "00000") or (Current_time > "00000" and Current_time < "10100")) else '0' ;

    -- Next state logic for the time counter
    Next_time <= Current_time + '1' when Current_time < "10011" else "00000";

    -- Current state logic for the time counter
    Current_time <= Next_time when (clk'event and clk='1' and Start = '1' and Next_out = "0000");

    -- Chip Select (CS) signal control logic
    CS <= '0' when ((Start = '1' and Current_time < "10011") or (Current_time = "10011" and Current_out < "0101")) else '1';

    -- Time signal logic based on the current time state
    with Current_time select
        Tim <= '0' when "00000",
                 '0' when "00001",
                 '0' when "00010",
                 '0' when "00011",
                 '1' when others;

    -- Next state logic for output counter
    Next_out <= Current_out + '1' when (Current_out < "1001" and Tim = '1') else "0000";

    -- Current state logic for output counter
    Current_out <= Next_out when clk'event and clk='1' and Tim = '1';

    -- Clock signal for LED matrix control
    clock <= '1' when (Current_out < "0101" and Tim = '1') else '0';

    -- Data input is always set to '1' for testing the matrix
    din <= '1';

end Behavioral;