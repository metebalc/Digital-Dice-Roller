library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity TopEntity is
    Port (
      CLOCK_50 : in  STD_LOGIC;                    -- 50 MHz input clock
      KEY      : in  STD_LOGIC_VECTOR(1 downto 0); -- Buttons: KEY0 (Roll), KEY1 (Reset)
      SW		  : in  STD_LOGIC_VECTOR(2 downto 0);  -- Switches: display the amount of dice in binary
		  HEX0     : out STD_LOGIC_VECTOR(6 downto 0); -- 7-segment display output
		  HEX1     : out STD_LOGIC_VECTOR(6 downto 0);
		  HEX2     : out STD_LOGIC_VECTOR(6 downto 0);
		  HEX3     : out STD_LOGIC_VECTOR(6 downto 0);
		  HEX4     : out STD_LOGIC_VECTOR(6 downto 0);
		  HEX5     : out STD_LOGIC_VECTOR(6 downto 0)
    );
end TopEntity;

architecture Behavioral of TopEntity is

    -- Signals for internal connections
    signal slow_clk_enable : std_logic;           
    signal debounced_key0  : std_logic;           
    signal debounced_key1  : std_logic;           
    signal random_value    : std_logic_vector(2 downto 0); 

    -- Component declarations
    component clock
        port (
            clk             : in  std_logic;
            slow_clk_enable : out std_logic
        );
    end component;

    component DFF_Debouncing_Button
        port (
            clk          : in  std_logic;
            clock_enable : in  std_logic;
            D            : in  std_logic;
            Q            : out std_logic
        );
    end component;

    component LFSR_Randomizer
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

	 component FSM
		  port (
			  clock    : in  std_logic;                -- Clock signal
			  reset    : in  std_logic;                -- Reset signal
			  key0	  : in  std_logic;
			  switches : in  std_logic_vector(2 downto 0); -- 3-bit switch input
			  HEX0     : out std_logic_vector(6 downto 0);
			  HEX1     : out std_logic_vector(6 downto 0);
			  HEX2     : out std_logic_vector(6 downto 0);
			  HEX3     : out std_logic_vector(6 downto 0);
			  HEX4     : out std_logic_vector(6 downto 0);
			  HEX5     : out std_logic_vector(6 downto 0)
		  );
	 end component;

begin
    U_Clock_Enable : clock
        port map (
            clk             => CLOCK_50,
            slow_clk_enable => slow_clk_enable
        );

    -- Instantiate DFF_Debouncing_Button for KEY0
    U_DFF_KEY0 : DFF_Debouncing_Button
        port map (
            clk          => CLOCK_50,
            clock_enable => slow_clk_enable,
            D            => not KEY(0),
            Q            => debounced_key0
        );

		  
    -- Instantiate DFF_Debouncing_Button for KEY1
    U_DFF_KEY1 : DFF_Debouncing_Button
        port map (
            clk          => CLOCK_50,
            clock_enable => slow_clk_enable,
            D            => not KEY(1),
            Q            => debounced_key1
        );

	 U_FSM : FSM
	    port map (
			clock => CLOCK_50,
			reset => debounced_key1,
			key0  => debounced_key0,
			switches => SW,
			HEX0 => HEX0,
			HEX1 => HEX1,
			HEX2 => HEX2,
			HEX3 => HEX3,
			HEX4 => HEX4,
			HEX5 => HEX5
		 );
		  

end Behavioral;
