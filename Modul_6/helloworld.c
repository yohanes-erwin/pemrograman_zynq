#include <stdio.h>
#include <stdint.h>
#include "sleep.h"

uint32_t *multiplier_p = (uint32_t *)0x40000000;

int main()
{
	while (1)
    {
		*(multiplier_p+0) = 25;
		*(multiplier_p+1) = 5;
		printf("%d\n", (unsigned int)*(multiplier_p+2));
	}
	
    return 0;
}
