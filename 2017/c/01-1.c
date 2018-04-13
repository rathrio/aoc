#include <stdio.h>
#include <string.h>

int parse_int(char c)
{
    return c - '0';
}

int main(int argc, const char *argv[])
{
    int sum = 0;
    int num_digits = strlen(argv[1]);

    int next_i;

    for (int i = 0; i < num_digits; i++) {
        if (i == num_digits - 1) {
            next_i = 0;
        } else {
            next_i = i + 1;
        }

        int current = parse_int(argv[1][i]);
        int next = parse_int(argv[1][next_i]);

        if (current == next) {
            sum += current;
        }
    }

    printf("%d\n", sum);
    return 0;
}
