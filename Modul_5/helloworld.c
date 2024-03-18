#include <stdio.h>
#include <stdint.h>
#include "sleep.h"

uint32_t *led_p = (uint32_t *)0x41200000;

int main()
{
    while (1)
    {
        printf("0xA\n");
        *(led_p+0) = 0xA;
        sleep(1);
        printf("0x5\n");
        *(led_p+0) = 0x5;
        sleep(1);
    }

    return 0;
}
