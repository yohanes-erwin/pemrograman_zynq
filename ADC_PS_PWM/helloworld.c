#include <stdio.h>
#include <stdint.h>
#include <sleep.h>

uint32_t *adc_reg_p = (uint32_t *)0x40000000;
uint32_t *pwm_reg_p = (uint32_t *)0x60000000;
unsigned int adc_data;
unsigned int pwm_val;

int map(int x, int in_min, int in_max, int out_min, int out_max)
{
  return (x-in_min)*(out_max-out_min) / (in_max-in_min)+out_min;
}

int main()
{
	while (1)
	{
		adc_data = *(adc_reg_p+0);
		pwm_val = map(adc_data, 0, 4095, 1, 99);
		*(pwm_reg_p+0) = pwm_val;

		printf("%d,", adc_data);
		printf("%d\n", pwm_val);

		usleep(100000);
	}
    return 0;
}
