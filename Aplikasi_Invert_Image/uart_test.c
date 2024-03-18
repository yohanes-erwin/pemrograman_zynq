#include "xparameters.h"
#include "xstatus.h"
#include "xil_types.h"
#include "xil_assert.h"
#include "xuartps_hw.h"
#include "xil_printf.h"

#define UART_BASEADDR	XPAR_XUARTPS_0_BASEADDR
#define BUF_SIZE		2048

char buf[BUF_SIZE];
int i, j;

void UART1_Init(void);
void UART1_PutString(char *s);

int main(void)
{
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
			// Send a string
			UART1_PutString(buf);
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
