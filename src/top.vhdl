-- top.vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Top is
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
end Top;

architecture Behavioral of Top is
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

    signal reg_out : STD_LOGIC_VECTOR(63 downto 0);
    signal alu_out : STD_LOGIC_VECTOR(63 downto 0);
    signal alu_c : STD_LOGIC;
    signal alu_z : STD_LOGIC;

begin
    regs_inst: Registers
        Port map (
            clk => clk,
            reset => reset,
            we => we,
            addr => reg_addr,
            data_in => alu_out, -- Пример использования ALU для записи
            data_out => reg_out
        );

    alu_inst: ALU
        Port map (
            a => alu_a,
            b => alu_b,
            opcode => alu_opcode,
            result => alu_out,
            carry => alu_c,
            zero => alu_z
        );

    reg_data_out <= reg_out;
    alu_result <= alu_out;
    alu_carry <= alu_c;
    alu_zero <= alu_z;
end Behavioral;
