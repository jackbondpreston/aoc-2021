#include <stdio.h>
#include <stdlib.h>

#define PARTB

int main() {
    FILE *f = fopen("input.txt", "r");
    if (!f) return 1;

    char opcode[16];
    int operand = 0, ret = 0;

    int depth = 0, distance = 0, aim = 0;

    int processed = 0;

    while ((ret = fscanf(f, "%s %d", opcode, &operand)) > 0) {
        switch (opcode[0]) {
            case 'f': //forward
                distance += operand;
#ifdef PARTB
                depth    += aim * operand;
#endif
                break;
            case 'd': //down
#ifndef PARTB
                depth += operand;
#else
                aim   += operand;
#endif
                break;
            case 'u': // up
#ifndef PARTB
                depth -= operand;
#else
                aim   -= operand;
#endif
                break;
        }

        printf("%d\n", aim);

        processed++;
    }

    printf("finished processing %d instrs\n", processed);
    printf("final depth: %d, distance: %d\n", depth, distance);
    printf("mult: %d*%d=%d\n", distance, depth, distance * depth);

    return 0;
}