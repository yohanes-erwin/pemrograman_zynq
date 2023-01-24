#include <stdio.h>
#include <stdint.h>

#define MEM_INP_BASE 0x40000000
#define MEM_OUT_BASE 0x42000000
#define CTRL_BASE 0x60000000
#define NUM_OF_INPUT 8

uint32_t *meminp_p, *memout_p, *ctrl_p;

int main()
{
	while (1)
	{
		// *** Initialize pointer ***
		meminp_p = (uint32_t *)MEM_INP_BASE;
		memout_p = (uint32_t *)MEM_OUT_BASE;
		ctrl_p = (uint32_t *)CTRL_BASE;

		// Write gain
		*(ctrl_p+1) = 10;
		// *** Write input ***
		printf("\nInput: ");
		for (int i = 0; i < NUM_OF_INPUT; i++)
		{
			*(meminp_p+i) = i+1;
			printf("%d, ", (unsigned int)*(meminp_p+i));
		}

		// Write number of input and set start bit
		*(ctrl_p+0) = (1 << 10) | NUM_OF_INPUT*4;
		
		// Polling until process is done
		while (!(*(ctrl_p+0) & (1 << 11)));
		
		// *** Read from block memory output ***
		printf("\nOutput: ");
		for (int i = 0; i < NUM_OF_INPUT; i++)
			printf("%d, ", (unsigned int)*(memout_p+i));
		printf("\n");
		
		sleep(1);
	}
	
	return 0;
}