#ifndef PERIPHERALS_H
#define PERIPHERALS_H

#include <stdint.h>
#include "cpu.h"

// Обработчики периферийных устройств
void handle_keyboard_interrupt(CPU *cpu);
void handle_display_update(CPU *cpu);

#endif // PERIPHERALS_H
