CC = gcc
CFLAGS = -Wall -Wextra -O2
SRC = src/cpu.c src/alu.c src/peripherals.c src/utils.c src/main.c
OBJ = $(SRC:.c=.o)
TARGET = emulator

all: $(TARGET)

$(TARGET): $(OBJ)
	$(CC) $(CFLAGS) -o $@ $^

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -f src/*.o $(TARGET)

.PHONY: all clean
