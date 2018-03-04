/********************************
Author: Sravanthi Kota Venkata
********************************/

#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include "segment.h"

#ifndef M_PI
#define M_PI 3.141592653589793
#endif

// dissimilarity measure between pixels
float diff(F2D *r, int x1, int y1, int x2, int y2) 
{
  return sqrt(abs(( subsref(r,y1,x1) * subsref(r,y1,x1)) - ( subsref(r,y2,x2) * subsref(r,y2,x2))));
}

I2D *segment_image(I2D* im, float sigma, float c, int min_size, int *num_ccs) 
{
    int width = im->width;
    int height = im->height;
    int num = 0, x, y, i;
    F2D* smooth_im;
    I2D *output;
    edge* edges;
    int components = 0;
/*  int *colors = (int *) malloc(width*height*sizeof(int)); */
    int *segments = (int *) malloc(height*width*sizeof(int));

    // smooth each color channel  
    smooth_im = imageBlur(im);

    //build graph
    edges = (edge*)malloc(sizeof(edge)*width*height*4);

    for (y = 0; y < height; y++) 
    {
        for (x = 0; x < width; x++) 
        {
            segments[y*width+x] = -1;
            if (x < width-1) 
            {
        	    edges[num].a = y * width + x;
	            edges[num].b = y * width + (x+1);
	            edges[num].w = diff(smooth_im, x, y, x+1, y);
	            num++;
            }

            if (y < height-1) 
            {
	            edges[num].a = y * width + x;
	            edges[num].b = (y+1) * width + x;
	            edges[num].w = diff(smooth_im, x, y, x, y+1);
	            num++;
            }

            if ((x < width-1) && (y < height-1)) 
            {
	            edges[num].a = y * width + x;
	            edges[num].b = (y+1) * width + (x+1);
	            edges[num].w = diff(smooth_im, x, y, x+1, y+1);
	            num++;
            }

            if ((x < width-1) && (y > 0)) 
            {
	            edges[num].a = y * width + x;
	            edges[num].b = (y-1) * width + (x+1);
	            edges[num].w = diff(smooth_im, x, y, x+1, y-1);
	            num++;
            }
        }
    }

    free(smooth_im);

    // segment
    universe *u = segment_graph(width*height, num, edges, c);
  
    // post process small components
    for (i = 0; i < num; i++) 
    {
        int a, b;
        a = find(u,edges[i].a);
        b = find(u,edges[i].b);
        if ((a != b) && ((u->elts[a].size < min_size) || (u->elts[b].size < min_size)))
            join(u, a, b);
    }

    free(edges);
    arrayref(num_ccs,0) = u->num;

    // pick random colors for each component
    output = iMallocHandle(height, width);

/*    srand(time(0));
    for (i = 0; i < width*height; i++)
    {
        float temp;
        temp = rand()/((float)RAND_MAX);
        colors[i] = (int)(temp*255);
    }
*/
   
    for (y = 0; y < height; y++) 
    {
        for (x = 0; x < width; x++) 
        {
            int comp;
            comp = find(u, y * width + x);
            if(segments[comp] == -1)
                segments[comp] = components++;
            subsref(output, y, x) = segments[comp];
        }
    }  
  
/*
    for (y = 0; y < height; y++) 
    {
        for (x = 0; x < width; x++) 
        {
            int comp;
            comp = find(u, y * width + x);
            subsref(output, y, x) = colors[comp];
        }
    }  
*/
    free(u->elts);
    free(u);
    free(segments);
    
    return output;
}


