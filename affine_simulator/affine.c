//Simulate an affine transform
//Note must compile with -lm

//Note this doesn't currently work :)

#include <stdio.h>
#include <fenv.h>
#include <math.h>
#include <stdint.h>
#include <assert.h>

#pragma STDC FENV_ACCESS on

int8_t mult_trunc(int32_t a, double b);


int main(int argc, char *argv[])
{
	assert(argc == 3); //Need two input args x, y
	
	fesetround(FE_TOWARDZERO); //Truncate

	int8_t x_in, y_in;

	x_in = atoi(argv[1]);
	y_in = atoi(argv[2]);

	printf("X in:\t%d\n", x_in);
	printf("Y in:\t%d\n", y_in);

	int8_t x1, x2, x3, y1, y2, y3, x_out, y_out;

	x1 = mult_trunc(x_in,0.5 * (2<<4) );
	x2 = mult_trunc(y_in,-0.875 * (2<<4));
	x3 = 5;

	y1 = mult_trunc(x_in,-0.875 * );
	y2 = mult_trunc(y_in,0.75);
	y3 = 12;

	x_out = x1 + x2 + x3;
	y_out = y1 + y2 + y3;

	printf("X out:\t%d\n", x_out);
	printf("Y out:\t%d\n", y_out);


return 0;
}

//Multiply and truncate answer
int8_t mult_trunc(int32_t a, int32_t b)
{

	a = a * b;

	a = a >> 4;

	return (int8_t) a;
}
