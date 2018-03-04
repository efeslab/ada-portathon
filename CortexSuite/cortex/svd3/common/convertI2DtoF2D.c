#include "sdvbs_common.h"

F2D * convertI2DtoF2D(I2D * in)
{
	F2D * out = fSetArray(in->height, in->width, 0);

	int i, j;
	for (i = 0; i < in->height; i++)
		for (j = 0; j < in->width; j++)
			subsref(out, i, j) = (float) subsref(in, i, j);

	return out;
}
