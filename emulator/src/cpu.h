#ifndef CPU_H
#define CPU_H

#include <stdint.h>
#include <stdbool.h>

// Количество регистров
#define NUM_REGISTERS 8

// Размер памяти (например, 1 МБ)
#define MEMORY_SIZE (1024 * 1024)

// Структура процессора
typedef struct {
    uint64_t registers[NUM_REGISTERS]; // ra, rb, rc, rd, re, rf, rg, rh
    uint64_t pc;                        // Program Counter
    uint64_t sp;                        // Stack Pointer
    uint8_t memory[MEMORY_SIZE];        // Оперативная память
    bool running;                       // Флаг выполнения
} CPU;

// Инициализация процессора
void cpu_init(CPU *cpu);

// Загрузка программы в память
bool cpu_load_program(CPU *cpu, const uint8_t *program, size_t size, uint64_t address);

// Выполнение одного цикла (одной инструкции)
void cpu_step(CPU *cpu);

// Запуск эмуляции до завершения
void cpu_run(CPU *cpu);

#endif // CPU_H