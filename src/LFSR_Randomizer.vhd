library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Randomizer is
  generic (
    seed  : integer := 1;          
    width : integer := 8           
  );
  port (
    cout   : out std_logic_vector(2 downto 0); -- Output limited to 1 to 6 (3 bits)
    CE     : in  std_logic;                   -- Enable signal
    CLK    : in  std_logic;                   -- Clock signal
    SCLR   : in  std_logic                    -- Synchronous clear/reset
  );
end entity;

architecture rtl of Randomizer is
    signal count           : std_logic_vector(width-1 downto 0) := std_logic_vector(to_unsigned(seed, width));
    signal linear_feedback : std_logic;
    signal limited_output  : unsigned(2 downto 0); 
begin

    -- Linear feedback logic: XOR taps (MSB and a middle bit)
    linear_feedback <= not(count(width-1) xor count(width/2));

    process (CLK)
    begin
        if rising_edge(CLK) then
            if SCLR = '1' then
                count <= std_logic_vector(to_unsigned(seed, width)); 
            elsif CE = '1' then
                count(width-1 downto 1) <= count(width-2 downto 0);
                count(0) <= linear_feedback;
            end if;
        end if;
    end process;

    -- Modulus operation to limit output to 0-5, then adjust to 1-6
    limited_output <= unsigned(count) mod 6 + 1;
    cout <= std_logic_vector(limited_output);

end architecture;
