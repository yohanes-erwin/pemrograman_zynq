#include <stdio.h>
#include <stdint.h>
#include <sleep.h>

#define MEM_INP_BASE 0x40000000 // Sesuaikan dengan address editor di Vivado
#define MEM_OUT_BASE 0x42000000 // Sesuaikan dengan address editor di Vivado

uint32_t *meminp_p, *memout_p;

int main()
{
	while (1)
	{
		// *** Initialize pointer ***
		meminp_p = (uint32_t *)MEM_INP_BASE;
		memout_p = (uint32_t *)MEM_OUT_BASE;

		// *** Write to block memory input ***
		for (int i = 0; i <= 15; i++)
			*(meminp_p+i) = i;

		// *** Read from block memory input ***
		printf("Block Memory Input: ");
		for (int i = 0; i <= 15; i++)
			printf("%d, ", (unsigned int)*(meminp_p+i));

		// *** Write to block memory output ***
		for (int i = 0; i <= 15; i++)
			*(memout_p+i) = 15-i;

		// *** Read from block memory output ***
		printf("\nBlock Memory Output: ");
		for (int i = 0; i <= 15; i++)
			printf("%d, ", (unsigned int)*(memout_p+i));
		printf("\n\n");

		sleep(1);
	}

	return 0;
}
