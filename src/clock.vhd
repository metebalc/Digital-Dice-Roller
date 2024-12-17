library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity clock is
    port(
        clk : in  std_logic;  -- Input clock on FPGA (100MHz)
        slow_clk_enable : out std_logic
    );
end clock;

architecture Behavioral of clock is
    signal counter : std_logic_vector(27 downto 0) := (others => '0');
begin
    process(clk)
    begin
        if rising_edge(clk) then
            counter <= counter + x"0000001";
            if counter >= x"003D08F" then  -- Reduce this number for simulation
                counter <= (others => '0');
            end if;
        end if;
    end process;

    slow_clk_enable <= '1' when counter = x"003D08F" else '0'; -- Reduce this number for simulation
end Behavioral;
