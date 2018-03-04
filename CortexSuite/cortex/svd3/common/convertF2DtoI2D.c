#include "sdvbs_common.h"

I2D * convertF2DtoI2D(F2D * in)
{
	I2D * out = iSetArray(in->height, in->width, 0);

	int i, j;
	for (i = 0; i < in->height; i++)
		for (j = 0; j < in->width; j++)
			subsref(out, i, j) = (int) round(subsref(in, i, j));

	return out;
}
