library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FSM is
    Port (
        clock    : in  std_logic;                
        reset    : in  std_logic;                
		    key0     : in  std_logic;
        switches : in  std_logic_vector(2 downto 0); --3-bit switch input
        HEX0     : out std_logic_vector(6 downto 0);
        HEX1     : out std_logic_vector(6 downto 0);
        HEX2     : out std_logic_vector(6 downto 0);
        HEX3     : out std_logic_vector(6 downto 0);
        HEX4     : out std_logic_vector(6 downto 0);
        HEX5     : out std_logic_vector(6 downto 0)
    );
end FSM;

architecture Behavioral of FSM is

    -- Signals for internal connections
    signal random_values : std_logic_vector(2 downto 0) := (others => '0');
    signal current_state : std_logic_vector(2 downto 0) := (others => '0'); 

    -- Component declarations
    component Randomizer
        generic (
            seed  : integer;
            width : integer
        );
        port (
            CLK  : in  std_logic;
            SCLR : in  std_logic;
            CE   : in  std_logic;
            cout : out std_logic_vector(2 downto 0)
        );
    end component;
    
	 component SegDecoder
        port (
            BCD_in  : in  std_logic_vector(2 downto 0);
            seg_out : out std_logic_vector(6 downto 0)
        );
    end component;	 

    -- Signals for Randomizer outputs
    signal rand_out1, rand_out2, rand_out3, rand_out4, rand_out5, rand_out6 : std_logic_vector(2 downto 0);
	  signal bcd_out1, bcd_out2, bcd_out3, bcd_out4, bcd_out5, bcd_out6 : std_logic_vector(2 downto 0);

begin
    Randomizer1 : Randomizer
        generic map (
            seed  => 0,
            width => 3
        )
        port map (
            CLK  => clock,
            SCLR => reset,
            CE   => key0, -- Always enabled
            cout => rand_out1
        );

    Randomizer2 : Randomizer
        generic map (
            seed  => 1,
            width => 3
        )
        port map (
            CLK  => clock,
            SCLR => reset,
            CE   => key0, 
            cout => rand_out2
        );

    Randomizer3 : Randomizer
        generic map (
            seed  => 2,
            width => 3
        )
        port map (
            CLK  => clock,
            SCLR => reset,
            CE   => key0, 
            cout => rand_out3
        );

    Randomizer4 : Randomizer
        generic map (
            seed  => 3,
            width => 3
        )
        port map (
            CLK  => clock,
            SCLR => reset,
            CE   => key0, 
            cout => rand_out4
        );

    Randomizer5 : Randomizer
        generic map (
            seed  => 4,
            width => 3
        )
        port map (
            CLK  => clock,
            SCLR => reset,
            CE   => key0, 
            cout => rand_out5
        );

    Randomizer6 : Randomizer
        generic map (
            seed  => 5,
            width => 3
        )
        port map (
            CLK  => clock,
            SCLR => reset,
            CE   => key0, 
            cout => rand_out6
        );

    -- Display logic based on switches
    process (switches)
    begin
        case switches is
            when "001" => -- 1 dice
					 bcd_out1 <= rand_out1; -- Display dice 1
                bcd_out2 <= "111"; -- Blank the rest
                bcd_out3 <= "111";
                bcd_out4 <= "111";
                bcd_out5 <= "111";
                bcd_out6 <= "111";

            when "010" => -- 2 dice
                bcd_out1 <= rand_out1;
                bcd_out2 <= rand_out2;
                bcd_out3 <= "111"; -- Blank unused displays
                bcd_out4 <= "111";
                bcd_out5 <= "111";
                bcd_out6 <= "111";

            when "011" => -- 3 dice
                bcd_out1 <= rand_out1;
                bcd_out2 <= rand_out2;
                bcd_out3 <= rand_out3;
                bcd_out4 <= "111"; -- Blank unused displays
                bcd_out5 <= "111";
                bcd_out6 <= "111";

            when "100" => -- 4 dice
                bcd_out1 <= rand_out1;
                bcd_out2 <= rand_out2;
                bcd_out3 <= rand_out3;
                bcd_out4 <= rand_out4;
                bcd_out5 <= "111"; -- Blank unused displays
                bcd_out6 <= "111";

            when "101" => -- 5 dice
                bcd_out1 <= rand_out1;
                bcd_out2 <= rand_out2;
                bcd_out3 <= rand_out3;
                bcd_out4 <= rand_out4;
                bcd_out5 <= rand_out5;
                bcd_out6 <= "111"; -- Blank unused display

            when "110" => -- 6 dice
                bcd_out1 <= rand_out1;
                bcd_out2 <= rand_out2;
                bcd_out3 <= rand_out3;
                bcd_out4 <= rand_out4;
                bcd_out5 <= rand_out5;
                bcd_out6 <= rand_out6;

            when others => -- Default case, blank all displays
                bcd_out1 <= "111";
                bcd_out2 <= "111";
                bcd_out3 <= "111";
                bcd_out4 <= "111";
                bcd_out5 <= "111";
                bcd_out6 <= "111";
        end case;
    end process;

    Decoder0 : SegDecoder
        port map (
            BCD_in  => bcd_out1,
            seg_out => HEX0
        );

    Decoder1 : SegDecoder
        port map (
            BCD_in  => bcd_out2,
            seg_out => HEX1
        );

    Decoder2 : SegDecoder
        port map (
            BCD_in  => bcd_out3,
            seg_out => HEX2
        );

    Decoder3 : SegDecoder
        port map (
            BCD_in  => bcd_out4,
            seg_out => HEX3
        );

    Decoder4 : SegDecoder
        port map (
            BCD_in  => bcd_out5,
            seg_out => HEX4
        );

    Decoder5 : SegDecoder
        port map (
            BCD_in  => bcd_out6,
            seg_out => HEX5
        );

end Behavioral;
