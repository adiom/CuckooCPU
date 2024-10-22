#include "cpu.h"
#include "alu.h"
#include "peripherals.h"
#include <string.h>
#include <stdio.h>

// Определение инструкций (опкоды)
typedef enum {
    OP_MOV = 0x1,
    OP_ADD = 0x2,
    OP_SUB = 0x3,
    OP_LOAD = 0x4,
    OP_STORE = 0x5,
    OP_JMP = 0x6,
    // Добавьте остальные инструкции по мере необходимости
} Opcode;

// Инициализация процессора
void cpu_init(CPU *cpu) {
    memset(cpu->registers, 0, sizeof(cpu->registers));
    cpu->pc = 0;
    cpu->sp = MEMORY_SIZE - 1; // Стек растет вниз
    memset(cpu->memory, 0, sizeof(cpu->memory));
    cpu->running = true;
}

// Загрузка программы в память
bool cpu_load_program(CPU *cpu, const uint8_t *program, size_t size, uint64_t address) {
    if (address + size > MEMORY_SIZE) {
        fprintf(stderr, "Ошибка: программа превышает размер памяти.\n");
        return false;
    }
    memcpy(&cpu->memory[address], program, size);
    cpu->pc = address;
    return true;
}

// Чтение 64-битного значения из памяти
uint64_t read_memory_uint64(CPU *cpu, uint64_t address) {
    if (address + 8 > MEMORY_SIZE) {
        fprintf(stderr, "Ошибка: попытка чтения за пределами памяти.\n");
        return 0;
    }
    uint64_t value = 0;
    for (int i = 0; i < 8; i++) {
        value |= ((uint64_t)cpu->memory[address + i]) << (i * 8);
    }
    return value;
}

// Запись 64-битного значения в память
void write_memory_uint64(CPU *cpu, uint64_t address, uint64_t value) {
    if (address + 8 > MEMORY_SIZE) {
        fprintf(stderr, "Ошибка: попытка записи за пределами памяти.\n");
        return;
    }
    for (int i = 0; i < 8; i++) {
        cpu->memory[address + i] = (value >> (i * 8)) & 0xFF;
    }
}

// Выполнение одной инструкции
void cpu_step(CPU *cpu) {
    if (cpu->pc + 8 > MEMORY_SIZE) {
        fprintf(stderr, "Ошибка: PC вышел за пределы памяти.\n");
        cpu->running = false;
        return;
    }

    // Чтение 64-битной инструкции
    uint64_t instruction = read_memory_uint64(cpu, cpu->pc);
    cpu->pc += 8; // Предполагается, что каждая инструкция 64 бита (8 байт)

    // Разбор инструкции
    uint8_t opcode = (instruction >> 60) & 0xF; // Первые 4 бита
    uint8_t reg_code = (instruction >> 56) & 0xF; // Следующие 4 бита
    uint64_t operand = instruction & 0x00FFFFFFFFFFFFFF; // Остальные 60 бит

    switch (opcode) {
        case OP_MOV:
            if (reg_code < NUM_REGISTERS) {
                cpu->registers[reg_code] = operand;
            } else {
                fprintf(stderr, "Ошибка: неверный код регистра %u в MOV.\n", reg_code);
            }
            break;
        case OP_ADD:
            if (reg_code < NUM_REGISTERS) {
                cpu->registers[reg_code] = alu_add(cpu->registers[reg_code], operand);
            } else {
                fprintf(stderr, "Ошибка: неверный код регистра %u в ADD.\n", reg_code);
            }
            break;
        case OP_SUB:
            if (reg_code < NUM_REGISTERS) {
                cpu->registers[reg_code] = alu_sub(cpu->registers[reg_code], operand);
            } else {
                fprintf(stderr, "Ошибка: неверный код регистра %u в SUB.\n", reg_code);
            }
            break;
        case OP_LOAD:
            // Загрузка из памяти по адресу operand в регистр reg_code
            if (reg_code < NUM_REGISTERS) {
                cpu->registers[reg_code] = read_memory_uint64(cpu, operand);
            } else {
                fprintf(stderr, "Ошибка: неверный код регистра %u в LOAD.\n", reg_code);
            }
            break;
        case OP_STORE:
            // Сохранение значения регистра reg_code по адресу operand
            if (reg_code < NUM_REGISTERS) {
                write_memory_uint64(cpu, operand, cpu->registers[reg_code]);
            } else {
                fprintf(stderr, "Ошибка: неверный код регистра %u в STORE.\n", reg_code);
            }
            break;
        case OP_JMP:
            // Безусловный переход на адрес operand
            cpu->pc = operand;
            break;
        default:
            fprintf(stderr, "Ошибка: неизвестный опкод %u.\n", opcode);
            cpu->running = false;
            break;
    }
}

// Запуск эмуляции
void cpu_run(CPU *cpu) {
    while (cpu->running) {
        cpu_step(cpu);
    }
}

