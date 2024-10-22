-- alu_tb.vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ALU_tb is
end ALU_tb;

architecture Behavioral of ALU_tb is
    component ALU
        Port (
            a       : in  STD_LOGIC_VECTOR(63 downto 0);
            b       : in  STD_LOGIC_VECTOR(63 downto 0);
            opcode  : in  STD_LOGIC_VECTOR(3 downto 0);
            result  : out STD_LOGIC_VECTOR(63 downto 0);
            carry   : out STD_LOGIC;
            zero    : out STD_LOGIC
        );
    end component;

    signal a       : STD_LOGIC_VECTOR(63 downto 0) := (others => '0');
    signal b       : STD_LOGIC_VECTOR(63 downto 0) := (others => '0');
    signal opcode  : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
    signal result  : STD_LOGIC_VECTOR(63 downto 0);
    signal carry   : STD_LOGIC;
    signal zero    : STD_LOGIC;
begin
    uut: ALU
        Port map (
            a => a,
            b => b,
            opcode => opcode,
            result => result,
            carry => carry,
            zero => zero
        );

    stim_proc: process
    begin
        -- Тест 1: 1 + 2 = 3
        a <= x"0000000000000001";
        b <= x"0000000000000002";
        opcode <= "0001"; -- ADD
        wait for 10 ns;

        -- Тест 2: 5 - 3 = 2
        a <= x"0000000000000005";
        b <= x"0000000000000003";
        opcode <= "0010"; -- SUB
        wait for 10 ns;

        -- Тест 3: 0 + 0 = 0
        a <= x"0000000000000000";
        b <= x"0000000000000000";
        opcode <= "0001"; -- ADD
        wait for 10 ns;

        -- Тест 4: 10 - 10 = 0
        a <= x"000000000000000A";
        b <= x"000000000000000A";
        opcode <= "0010"; -- SUB
        wait for 10 ns;

        -- Тест 5: 0 - 1 (подтверждение работы вычитания)
        a <= x"0000000000000000";
        b <= x"0000000000000001";
        opcode <= "0010"; -- SUB
        wait for 10 ns;

        -- Завершение симуляции
        wait;
    end process;
end Behavioral;
