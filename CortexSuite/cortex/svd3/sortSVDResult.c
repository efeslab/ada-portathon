#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "common/sdvbs_common.h"

int compare_floats (const void *a, const void *b)
{
  return (int) - (* (float *)a - * (float *)b);
}

#define u(i, j) subsref(u, i, j)
#define s(i) subsref(s, 0, i)
#define v(i, j) subsref(v, i, j)
#define uCopy(i, j) subsref(uCopy, i, j)
#define vCopy(i, j) subsref(vCopy, i, j)
void sortSVDResult(F2D *u, F2D *s, F2D *v)
{
	float sCopy[s->width];
	memcpy(sCopy, s->data, s->width * sizeof(float));
	qsort (s->data, s->width, sizeof (float), compare_floats);

	F2D * uCopy = fDeepCopy(u);
	F2D * vCopy = fDeepCopy(v);

	int i,j,k;
	for (i = 0; i < s->width; i++)
	{
		for(j = 0; j < s->width; j++)
		{
			if (sCopy[j] == s(i))
			{
				sCopy[j] = -1;
				for (k = 0; k < u->height; k++)
				{
					u(k, i) = uCopy(k, j);
					v(k, i) = vCopy(k, j);
				}
				break;
			}
		}

	}

	free(uCopy);
	free(vCopy);
}
