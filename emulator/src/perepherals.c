#include "peripherals.h"
#include <stdio.h>

void handle_keyboard_interrupt(CPU *cpu) {
    // Пример обработки ввода с клавиатуры
    char input;
    printf("Ввод с клавиатуры: ");
    input = getchar();
    // Сохранение ввода в регистр ra (0)
    cpu->registers[0] = (uint64_t)input;
}

void handle_display_update(CPU *cpu) {
    // Пример обновления дисплея
    // Можно реализовать вывод содержимого framebuffer
    // В данном примере просто выводим значение регистра rb (1)
    printf("Display Update: %llu\n", cpu->registers[1]);
}
