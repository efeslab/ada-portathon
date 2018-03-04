/********************************
Author: Sravanthi Kota Venkata
********************************/

#include <stdio.h>
#include <stdlib.h>
#include "segment.h"

// threshold function
#define THRESHOLD(size, c) (c/size)

int find(universe* u, int x)
{
    int y=x;
    while (y != u->elts[y].p)
        y = u->elts[y].p;
    u->elts[x].p = y;
    return y;
}

void join(universe* u, int x, int y)
{
    if (u->elts[x].rank > u->elts[y].rank) 
    {
        u->elts[y].p = x;
        u->elts[x].size += u->elts[y].size;
    } 
    else 
    {
        u->elts[x].p = y;
        u->elts[y].size += u->elts[x].size;
        if (u->elts[x].rank == u->elts[y].rank)
            u->elts[y].rank++;
    }
    u->num--;
    return ;
}

universe *segment_graph(int num_vertices, int num_edges, edge *edges, float c) 
{ 
    float threshold[num_vertices];
    int i, a, b, j, k;
    universe *u;
    F2D *edgeWeights;
    I2D *indices;

    edgeWeights = fMallocHandle(1,num_edges);

    for(i=0; i<num_edges; i++)
        asubsref(edgeWeights,i) = edges[i].w;

    // sort edges by weight
    indices = fSortIndices(edgeWeights,1);

    // make a disjoint-set forest
    u = (universe*)malloc(sizeof(universe));
    u->elts = (uni_elt*)malloc(sizeof(uni_elt)*num_vertices);
    u->num = num_vertices;
    for(i=0; i<num_vertices; i++)
    {
        u->elts[i].rank = 0;
        u->elts[i].size = 1;
        u->elts[i].p = i;
    }

    // init thresholds
    for (i = 0; i < num_vertices; i++)
        arrayref(threshold,i) = THRESHOLD(1,c);

    // for each edge, in non-decreasing weight order...
    for (i = 0; i < num_edges; i++)
    {
        edge *pedge = &edges[ asubsref(indices,i) ];
    
        // components conected by this edge
        a = find(u, pedge->a);
        b = find(u, pedge->b);
        if (a != b) 
        {
            if ((pedge->w <= arrayref(threshold,a)) && (pedge->w <= arrayref(threshold,b))) 
            {
	            join(u, a, b);
	            a = find(u, a);
	            arrayref(threshold,a) = pedge->w + THRESHOLD(u->elts[a].size, c);
            }
        }
    }

    fFreeHandle(edgeWeights);
    iFreeHandle(indices);

  return u;
}

