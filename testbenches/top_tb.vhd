-- top_tb.vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Top_tb is
end Top_tb;

architecture Behavioral of Top_tb is
    component Top
        Port (
            clk     : in  STD_LOGIC;
            reset   : in  STD_LOGIC;
            we      : in  STD_LOGIC;
            reg_addr: in  INTEGER range 0 to 7;
            alu_opcode : in  STD_LOGIC_VECTOR(3 downto 0);
            alu_a   : in  STD_LOGIC_VECTOR(63 downto 0);
            alu_b   : in  STD_LOGIC_VECTOR(63 downto 0);
            reg_data_out : out STD_LOGIC_VECTOR(63 downto 0);
            alu_result    : out STD_LOGIC_VECTOR(63 downto 0);
            alu_carry     : out STD_LOGIC;
            alu_zero      : out STD_LOGIC
        );
    end component;

    signal clk     : STD_LOGIC := '0';
    signal reset   : STD_LOGIC := '0';
    signal we      : STD_LOGIC := '0';
    signal reg_addr: INTEGER range 0 to 7 := 0;
    signal alu_opcode : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
    signal alu_a   : STD_LOGIC_VECTOR(63 downto 0) := (others => '0');
    signal alu_b   : STD_LOGIC_VECTOR(63 downto 0) := (others => '0');
    signal reg_data_out : STD_LOGIC_VECTOR(63 downto 0);
    signal alu_result    : STD_LOGIC_VECTOR(63 downto 0);
    signal alu_carry     : STD_LOGIC;
    signal alu_zero      : STD_LOGIC;

    constant clk_period : time := 10 ns;
begin
    uut: Top
        Port map (
            clk => clk,
            reset => reset,
            we => we,
            reg_addr => reg_addr,
            alu_opcode => alu_opcode,
            alu_a => alu_a,
            alu_b => alu_b,
            reg_data_out => reg_data_out,
            alu_result => alu_result,
            alu_carry => alu_carry,
            alu_zero => alu_zero
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
        -- Сброс
        reset <= '1';
        wait for clk_period;
        reset <= '0';
        wait for clk_period;

        -- Запись 10 в регистр 0 через ALU (ADD 10 + 0)
        we <= '1';
        reg_addr <= 0;
        alu_opcode <= "0001"; -- ADD
        alu_a <= x"000000000000000A"; -- 10
        alu_b <= x"0000000000000000"; -- 0
        wait for clk_period;
        we <= '0';
        wait for clk_period;

        -- Запись 20 в регистр 1 через ALU (ADD 20 + 0)
        we <= '1';
        reg_addr <= 1;
        alu_opcode <= "0001"; -- ADD
        alu_a <= x"0000000000000014"; -- 20
        alu_b <= x"0000000000000000"; -- 0
        wait for clk_period;
        we <= '0';
        wait for clk_period;

        -- Выполнение вычитания: регистр 1 - регистр 0 (20 - 10 = 10)
        we <= '1';
        reg_addr <= 2; -- Запись в регистр 2
        alu_opcode <= "0010"; -- SUB
        alu_a <= x"0000000000000014"; -- 20 (регистры не подключены напрямую, пример)
        alu_b <= x"000000000000000A"; -- 10
        wait for clk_period;
        we <= '0';
        wait for clk_period;

        -- Завершение симуляции
        wait;
    end process;
end Behavioral;
