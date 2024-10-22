-- alu.vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ALU is
    Port (
        a       : in  STD_LOGIC_VECTOR(63 downto 0);
        b       : in  STD_LOGIC_VECTOR(63 downto 0);
        opcode  : in  STD_LOGIC_VECTOR(3 downto 0); -- 0001: ADD, 0010: SUB
        result  : out STD_LOGIC_VECTOR(63 downto 0);
        carry   : out STD_LOGIC;
        zero    : out STD_LOGIC
    );
end ALU;

architecture Behavioral of ALU is
begin
    process(a, b, opcode)
        variable temp_result : UNSIGNED(64 downto 0);
    begin
        case opcode is
            when "0001" => -- ADD
                temp_result := UNSIGNED('0' & a) + UNSIGNED('0' & b);
                result <= STD_LOGIC_VECTOR(temp_result(63 downto 0));
                carry <= temp_result(64);
            when "0010" => -- SUB
                temp_result := UNSIGNED('0' & a) - UNSIGNED('0' & b);
                result <= STD_LOGIC_VECTOR(temp_result(63 downto 0));
                carry <= '0'; -- В данном простом АЛУ не реализован флаг переполнения
            when others =>
                result <= (others => '0');
                carry <= '0';
        end case;

        if result = (others => '0') then
            zero <= '1';
        else
            zero <= '0';
        end if;
    end process;
end Behavioral;
