--This code is designed to operate the LED matrix with a 100 MHz clock 
-- Compatible with the MAX752 device
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL; -- Deprecated; consider using numeric_std instead
use IEEE.STD_LOGIC_UNSIGNED.ALL; -- Deprecated; consider using numeric_std instead

entity Led_Matrix_X is
port(
    clk: in std_logic;         -- Clock signal
    CS: out std_logic;         -- Chip Select signal
    clock: out std_logic;      -- Clock output
    din: out std_logic;        -- Data input
    Button: in std_logic;       -- Button input
    Bot_out: out std_logic     -- LED shows button press
);
end Led_Matrix_X;

architecture Behavioral of Led_Matrix_X is
    -- Signals for state tracking
    signal Current_Data: std_logic_vector(3 downto 0) := "0000"; -- Current data state
    signal Next_Data: std_logic_vector(3 downto 0) := "0000";   -- Next data state
    signal Current_time: std_logic_vector(4 downto 0) := "00000"; -- Current 19 counter state
    signal Next_time: std_logic_vector(4 downto 0) := "00000";   -- Next 19 counter state
    signal Current_5ns: std_logic_vector(3 downto 0) := "0000"; -- Current 5ns state
    signal Next_5ns: std_logic_vector(3 downto 0) := "0000";   -- Next 5ns state
    signal Cont_out: std_logic_vector(3 downto 0) := "0000"; -- counter output state
    signal Qsig: std_logic_vector(15 downto 0) := (others => '0'); -- Temporary data register
    signal Qs: std_logic_vector(15 downto 0) := (others => '0');   -- Data shift register
    signal Data: std_logic_vector(15 downto 0) := (others => '0'); 
    signal Tim: std_logic;     -- 4-state initialization delay
    signal Start: std_logic;     -- Start control signal
    signal LD_sh: std_logic;      -- Load/shift control signal
    signal EN: std_logic;         -- Enable signal
begin
    -- Start signal logic
    Start <= '1' when ((Button = '0' and Current_time = "00000") or 
                        (Current_Data > "0000") or 
                        (Current_time > "00000")) else '0';

    -- Output the button status
    Bot_out <= '1' when Button = '1' else '0';

    ----- Data generator -----
    -- Next state logic for data
    Next_Data <= Current_Data + '1' when (Current_Data < X"C") else (others => '0');

    -- Current state logic for data
    Current_Data <= Next_Data when (clk'event and clk = '1' and 
                                  Start = '1' and 
                                  Next_time = "00000" and 
                                  Next_5ns = "0000");

    -- Output logic for data
    -- Address configuration
    Data(15 downto 0) <= X"0900" when Current_Data = X"0" else
                         X"0A0F" when Current_Data = X"1" else
                         X"0B07" when Current_Data = X"2" else
                         X"0C01" when Current_Data = X"3" else
                         X"0F00" when Current_Data = X"4" else
    -- Print configuration
                         X"0181" when Current_Data = X"5" else
                         X"0242" when Current_Data = X"6" else
                         X"0324" when Current_Data = X"7" else
                         X"0418" when Current_Data = X"8" else
                         X"0518" when Current_Data = X"9" else
                         X"0624" when Current_Data = X"A" else
                         X"0742" when Current_Data = X"B" else
                         X"0881" when Current_Data = X"C" else
                         (others => '0');

    ----- 19-state counter (general-purpose counter) -----
    -- Next state logic for counter
    Next_time <= Current_time + '1' when Current_time < "10011" else (others => '0');

    -- Current state logic for counter
    Current_time <= Next_time when (clk'event and clk = '1' and Start = '1' and Next_5ns = "0000");

    -- signal logic for 4-state initialization delay
    Tim <= '0' when Current_time < 4 else '1';

    ----- 10-state counter - 5ns -----
    -- Next state logic for sub-time counter
    Next_5ns <= Current_5ns + '1' when (Current_5ns < "1001" and Tim = '1') else (others => '0');

    -- Current state logic for sub-time counter
    Current_5ns <= Next_5ns when clk'event and clk = '1' and Tim = '1';

    -- Output logic
    CS <= '0' when ((Start = '1' and Current_time < "10011") or 
                    (Current_time = "10011" and Current_5ns < "0101")) else '1';

    clock <= '1' when (Current_5ns < "0101" and Tim = '1') else '0';
    
    -- Counter output state update logic
    Cont_out <= Cont_out + '1' when (Current_5ns = X"6" and clk'event and clk = '1');
    EN <= '1' when Current_5ns = X"6" or Current_time = "0000" else '0';
    LD_sh <= '0' when Current_time = "0000" else '1';

    -- Next state for shift register
    Qsig <= Data when LD_sh = '0' else Qs(14 downto 0) & '0';

    -- Register logic
    Qs <= Qsig when clk'event and clk = '1' and EN = '1';

    -- Data output
    din <= Qs(15);
end Behavioral;
