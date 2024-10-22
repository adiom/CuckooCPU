#include "cpu.h"
#include <stdio.h>
#include <stdlib.h>

// Пример программы для эмуляции
// MOV ra, 10
// ADD ra, 20
// STORE ra, 100
// LOAD rb, 100
// JMP 40
uint8_t program[] = {
    0x10, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x0A, // MOV ra, 10
    0x20, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x14, // ADD ra, 20
    0x50, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x64, // STORE ra, 100
    0x40, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x64, // LOAD rb, 100
    0x60, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x28  // JMP 40
};

int main() {
    CPU cpu;
    cpu_init(&cpu);

    // Загрузка программы в память по адресу 0
    if (!cpu_load_program(&cpu, program, sizeof(program), 0)) {
        fprintf(stderr, "Не удалось загрузить программу в память.\n");
        return EXIT_FAILURE;
    }

    // Запуск эмуляции
    cpu_run(&cpu);

    // Вывод содержимого регистров после выполнения программы
    for (int i = 0; i < NUM_REGISTERS; i++) {
        printf("Register %d: %llu\n", i, cpu.registers[i]);
    }

    return EXIT_SUCCESS;
}
