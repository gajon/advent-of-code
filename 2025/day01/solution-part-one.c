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

i32 calculate_new_position(const i32 dial_position,
                           const RotationInstruction instruction) {
    i32 new_dial_position = dial_position;

    if (instruction.direction == 'L') {
        new_dial_position -= instruction.steps;
    } else {
        new_dial_position += instruction.steps;
    }

    return ((new_dial_position % 100) + 100) % 100;
}

int main(void) {
    FILE *file = open_file("input");
    i32 dial_position = 50;
    i32 at_zero_times = 0;
    enum { MAX_INSTRUCTION_SIZE = 32 };
    char instruction[MAX_INSTRUCTION_SIZE];

    printf("The dial starts by pointing at %d\n", dial_position);

    while (fgets(instruction, sizeof(instruction), file) != NULL) {
        RotationInstruction inst = parse_instruction(instruction);
        dial_position = calculate_new_position(dial_position, inst);

        if (dial_position == 0) {
            at_zero_times += 1;
        }

        printf("The dial is rotated %c%u to point at %d\n",
               inst.direction, inst.steps, dial_position);
    }
    printf("Password: %d\n", at_zero_times);

    fclose(file);
    return EXIT_SUCCESS;
}
