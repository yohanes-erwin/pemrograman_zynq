#include <stdio.h>
#include <stdint.h>
#include <sleep.h>

uint32_t *ann_p = (uint32_t *)0x40000000;

// *** Weight 1 ***
unsigned int w1[48] = { 512,  410, 205, 410, 0,   717, 819, 410,
						717,  410, 102, 717, 819, 717, 410, 205,
						512,  410, 717, 717, 205, 410, 922, 819,
						1024, 819, 102, 512, 410, 0,   410, 922,
						205,  614, 512, 307, 717, 307, 819, 307,
						102,  819, 512, 102, 417, 417, 417, 717 };
// *** Weight 2 ***
unsigned int w2[48] = { 512,  410, 205, 410, 0,   717,
						717,  410, 102, 717, 819, 717,
						512,  410, 717, 717, 205, 410,
						1024, 819, 102, 512, 410, 0,
						205,  614, 512, 307, 717, 307,
						102,  819, 512, 102, 410, 410,
						102,  922, 922, 614, 717, 307,
						102,  102, 512, 307, 410, 205 };
// *** Weight 3 ***
unsigned int w3[48] = { 512, 410, 205, 410,
						717, 410, 102, 717,
						512, 410, 717, 717,
						102, 819, 102, 512,
						205, 614, 512, 307,
						102, 819, 512, 102 };
// *** Weight 4 ***
unsigned int w4[8] =  { 512,  410,
						717,  410,
						512,  410,
						1024, 819};
// *** Input ***
unsigned int in[48] = { 512,  410, 205, 410, 0,   717,
						717,  410, 102, 717, 819, 717,
						512,  410, 717, 717, 205, 410,
						1024, 819, 102, 512, 410, 0,
						205,  614, 512, 307, 717, 307,
						102,  819, 512, 102, 410, 410,
						102,  922, 922, 614, 717, 307,
						102,  102, 512, 307, 410, 205 };

int i;

int main()
{
	printf("\nDNN start ===== \n");

	printf("w1: ");
	for (i = 4; i <= 51; i++)
	{
		*(ann_p+i) = w1[i-4];
		printf("%d, ", (unsigned int)*(ann_p+i));
	}
	printf("\n");

	printf("w2: ");
	for (i = 52; i <= 99; i++)
	{
		*(ann_p+i) = w2[i-52];
		printf("%d, ", (unsigned int)*(ann_p+i));
	}
	printf("\n");

	printf("w3: ");
	for (i = 100; i <= 123; i++)
	{
		*(ann_p+i) = w3[i-100];
		printf("%d, ", (unsigned int)*(ann_p+i));
	}
	printf("\n");

	printf("w4: ");
	for (i = 124; i <= 131; i++)
	{
		*(ann_p+i) = w4[i-124];
		printf("%d, ", (unsigned int)*(ann_p+i));
	}
	printf("\n");

	printf("In: ");
	for (i = 132; i <= 179; i++)
	{
		*(ann_p+i) = in[i-132];
		printf("%d, ", (unsigned int)*(ann_p+i));
	}
	printf("\n");

	while (*(ann_p+0) == 1);
	printf("Busy flag: %d\n", (unsigned int)*(ann_p+0));

	printf("Out: ");
	for (i = 132; i <= 147; i++)
		printf("%d, ", (unsigned int)*(ann_p+i));
	printf("\n");

	printf("Out (fixed-point): ");
	for (i = 132; i <= 147; i++)
		printf("%.6f, ", ((float)*(ann_p+i))/1024.0);
	printf("\n");

	printf("DNN end ===== \n");

	while (1);

    return 0;
}

