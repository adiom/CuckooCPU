-- registers.vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Registers is
    Port (
        clk     : in  STD_LOGIC;
        reset   : in  STD_LOGIC;
        we      : in  STD_LOGIC; -- Write Enable
        addr    : in  INTEGER range 0 to 7; -- Register address (0-7)
        data_in : in  STD_LOGIC_VECTOR(63 downto 0);
        data_out : out STD_LOGIC_VECTOR(63 downto 0)
    );
end Registers;

architecture Behavioral of Registers is
    type reg_array is array (0 to 7) of STD_LOGIC_VECTOR(63 downto 0);
    signal regs : reg_array := (others => (others => '0'));
begin
    process(clk, reset)
    begin
        if reset = '1' then
            regs <= (others => (others => '0'));
        elsif rising_edge(clk) then
            if we = '1' then
                regs(addr) <= data_in;
            end if;
        end if;
    end process;

    data_out <= regs(addr);
end Behavioral;

