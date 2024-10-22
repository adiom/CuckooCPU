-- registers_tb.vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Registers_tb is
end Registers_tb;

architecture Behavioral of Registers_tb is
    component Registers
        Port (
            clk     : in  STD_LOGIC;
            reset   : in  STD_LOGIC;
            we      : in  STD_LOGIC;
            addr    : in  INTEGER range 0 to 7;
            data_in : in  STD_LOGIC_VECTOR(63 downto 0);
            data_out : out STD_LOGIC_VECTOR(63 downto 0)
        );
    end component;

    signal clk     : STD_LOGIC := '0';
    signal reset   : STD_LOGIC := '0';
    signal we      : STD_LOGIC := '0';
    signal addr    : INTEGER range 0 to 7 := 0;
    signal data_in : STD_LOGIC_VECTOR(63 downto 0) := (others => '0');
    signal data_out : STD_LOGIC_VECTOR(63 downto 0);

    constant clk_period : time := 10 ns;
begin
    uut: Registers
        Port map (
            clk => clk,
            reset => reset,
            we => we,
            addr => addr,
            data_in => data_in,
            data_out => data_out
        );

    clk_process :process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

    stim_proc: process
    begin
        -- Reset the registers
        reset <= '1';
        wait for clk_period;
        reset <= '0';
        wait for clk_period;

        -- Write to register 0
        we <= '1';
        addr <= 0;
        data_in <= x"0000000000000001";
        wait for clk_period;
        we <= '0';
        wait for clk_period;

        -- Write to register 1
        we <= '1';
        addr <= 1;
        data_in <= x"0000000000000002";
        wait for clk_period;
        we <= '0';
        wait for clk_period;

        -- Read from register 0
        addr <= 0;
        wait for clk_period;

        -- Read from register 1
        addr <= 1;
        wait for clk_period;

        -- End simulation
        wait;
    end process;
end Behavioral;
