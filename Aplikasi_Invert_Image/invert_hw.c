#include "xparameters.h"
#include "xstatus.h"
#include "xil_types.h"
#include "xil_assert.h"
#include "xuartps_hw.h"
#include "xil_printf.h"
#include "stdio.h"
#include "stdlib.h"
#include "stdint.h"
#include "string.h"

#define UART_BASEADDR	XPAR_XUARTPS_0_BASEADDR
#define BUF_SIZE		2048

#define MEM_INP_BASE 	0x40000000
#define MEM_OUT_BASE 	0x42000000
#define CTRL_BASE 		0x41200000
#define IMAGE_SIZE 		784

char buf[BUF_SIZE];
unsigned char img[IMAGE_SIZE];
unsigned char inv_img[IMAGE_SIZE];
int i, j, k;

uint32_t *meminp_p, *memout_p, *ctrl_p;

void UART1_Init(void);
void UART1_PutString(char *s);

int main(void)
{
	// Initialize pointer
	meminp_p = (uint32_t *)MEM_INP_BASE;
	memout_p = (uint32_t *)MEM_OUT_BASE;
	ctrl_p = (uint32_t *)CTRL_BASE;

	while (1)
	{
		// Read received char. This function will Wait until there is data (blocking function)
		char c = XUartPs_RecvByte(UART_BASEADDR);

		// Store chars in "buf" until newline char ('\n')
		if (c != '\n')
		{
			// Concat char to buffer
			// If maximum buffer size is reached, then reset i to 0
			if (i < BUF_SIZE - 1)
			{
				buf[i] = c;
				i++;
			}
			else
			{
				buf[i] = c;
				i = 0;
			}
		}
		else
		{
			// String split every ','
			buf[i] = '\0';
			char *currnum;
			int n = 0;
			while ((currnum = strtok(n ? NULL : buf, ",")) != NULL)
			    img[n++] = atoi(currnum);

			// *** HW Invert ***************************************************
			// Write input
			for (int i = 0; i < IMAGE_SIZE; i++)
				*(meminp_p+i) = (unsigned int)img[i];

			// Start the core
			*(ctrl_p+0) = 1; // Set start
			*(ctrl_p+0) = 0; // Clear start

			// Polling until process is done
			while (!(*(ctrl_p+1) & (1 << 0)));

			// Read output
			for (int i = 0; i < IMAGE_SIZE; i++)
				inv_img[i] = (unsigned char)*(memout_p+i);
			// *****************************************************************

			// Send to UART
			for (j = 0; j < IMAGE_SIZE; j++)
			{
				char buffer[8];
				sprintf(buffer, "%u,", inv_img[j]);
				UART1_PutString(buffer);
				for (k = 0; k < 8; k++)
					buffer[k] = '\0';
			}
			XUartPs_SendByte(UART_BASEADDR, '\n'); // Send newline char

			// Clear buffer
			for (j = 0; j < BUF_SIZE; j++)
				buf[j] = '\0';
			i = 0;
		}
	}

	return 0;
}

void UART1_Init(void)
{
	// Enable TX and RX for the device
	u32 CntrlRegister = XUartPs_ReadReg(UART_BASEADDR, XUARTPS_CR_OFFSET);
	XUartPs_WriteReg(UART_BASEADDR, XUARTPS_CR_OFFSET,
			         ((CntrlRegister & ~XUARTPS_CR_EN_DIS_MASK) |
			         XUARTPS_CR_TX_EN | XUARTPS_CR_RX_EN));
}

void UART1_PutString(char *s)
{
	// Send a string
	while (*s)
		XUartPs_SendByte(UART_BASEADDR, *s++);
}
