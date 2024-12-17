library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity segDecoder is
    Port (
        BCD_in : in STD_LOGIC_VECTOR(2 downto 0);
        seg_out : out STD_LOGIC_VECTOR(6 downto 0) 
    );
end segDecoder;

architecture Behavioral of segDecoder is
begin
    process(BCD_in)
    begin
        case BCD_in is
            when "000" => seg_out <= "1000000"; -- Display 0
            when "001" => seg_out <= "1111001"; -- Display 1
            when "010" => seg_out <= "0100100"; -- Display 2
            when "011" => seg_out <= "0110000"; -- Display 3
            when "100" => seg_out <= "0011001"; -- Display 4
            when "101" => seg_out <= "0010010"; -- Display 5
            when "110" => seg_out <= "0000010"; -- Display 6
            when others => seg_out <= "1111111"; -- Blank or error
        end case;
    end process;
end Behavioral;
