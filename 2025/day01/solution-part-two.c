#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <assert.h>

typedef int32_t  i32;
typedef uint32_t ui32;

typedef struct {
    ui32 steps;
    char direction;
} RotationInstruction;

FILE* open_file(const char* filename) {
    FILE *file = fopen(filename, "r");
    assert(file);

    return file;
}

RotationInstruction parse_instruction(char* instruction) {
    instruction[strcspn(instruction, "\n")] = '\0'; // Removes the \n

    char direction = instruction[0];
    ui32 steps = (ui32)strtoul(instruction + 1, NULL, 10);

    RotationInstruction rotation_instruction = { steps, direction };
    return rotation_instruction;
}

ui32 apply_rotation(i32 *dial_position, const RotationInstruction instruction) {
    i32 new_dial_position = *dial_position;
    ui32 passes_over_zero = 0;

    if (instruction.direction == 'L') {
        // ROTATING TO THE LEFT.
        new_dial_position -= instruction.steps;

        // If we land in the negative, count how many times we rotated 100
        // positions. If it lands exactly at 0, count it as well.
        if (new_dial_position < 0) {
            passes_over_zero = (ui32)(new_dial_position / -100);

            // Add one more if the initial dial_position was not already at 0.
            if (*dial_position > 0) passes_over_zero++;

        } else if (new_dial_position == 0) {
            passes_over_zero = 1;
        }

    } else {
        // ROTATING TO THE RIGHT.
        new_dial_position += instruction.steps;
        passes_over_zero = (ui32)(new_dial_position / 100);
    }

    *dial_position = ((new_dial_position % 100) + 100) % 100;
    return passes_over_zero;
}

int main(void) {
    FILE *file = open_file("input");
    i32 dial_position = 50;
    ui32 at_zero_times = 0;
    enum { MAX_INSTRUCTION_SIZE = 32 };
    char instruction[MAX_INSTRUCTION_SIZE];

    printf("The dial starts by pointing at %d\n", dial_position);

    while (fgets(instruction, sizeof(instruction), file) != NULL) {
        RotationInstruction inst = parse_instruction(instruction);
        const ui32 crossings = apply_rotation(&dial_position, inst);

        at_zero_times += crossings;

        printf("The dial is rotated %c%u to point at %d (crossings %u)\n",
               inst.direction, inst.steps, dial_position, crossings);
    }
    printf("Password: %u\n", at_zero_times);

    fclose(file);
    return EXIT_SUCCESS;
}

// cc solution-part-two.c -o two.out -Wall -Wextra -Wconversion -Wsign-conversion -Wmisleading-indentation -pedantic -std=c11 && ./two.out
