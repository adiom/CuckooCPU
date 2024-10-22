#!/bin/bash

# Проверка аргументов
if [ "$#" -ne 1 ]; then
    echo "Использование: $0 <component>"
    echo "Компоненты: registers, alu"
    exit 1
fi

COMPONENT=$1

# Очистка папки sim
mkdir -p sim
rm -rf sim/*

# Компиляция
ghdl -a src/*.vhdl
ghdl -a testbenches/${COMPONENT}_tb.vhdl

# Синтез тестового стенда
ghdl -e ${COMPONENT}_tb

# Запуск симуляции
ghdl -r ${COMPONENT}_tb --vcd=sim/${COMPONENT}.vcd

echo "Симуляция завершена. Файл VCD находится в sim/${COMPONENT}.vcd"
