/********************************
Author: Sravanthi Kota Venkata
********************************/

/***
%   MSER  Maximally Stable Extremal Regions
%   R=MSER(I,DELTA) computes the Maximally Stable Extremal Regions
%   (MSER) of image I with stability threshold DELTA. I is any
%   array of class UINT8, while DELTA is a scalar of the same class.
%   R is an index set (of class UINT32) which enumerates the
%   representative pixels of the detected regions.
%
%   A region R can be recovered from a representative pixel X as the
%   connected component of the level set {Y:I(Y) <= I(X)} which
%   contains X.
***/


#include "mser.h"
#include <string.h>

#define MIN(a,b) (a<b)?a:b
#define MAX(a,b) (a>b)?a:b

typedef int  unsigned idx_t ;
typedef long long int unsigned acc_t ;

/* pairs are used to sort the pixels */
typedef struct 
{
  val_t value ; 
  idx_t  index ;
} pair_t ;

/* forest node */
typedef struct
{
  idx_t parent ;   /**< parent pixel         */
  idx_t shortcut ; /**< shortcut to the root */
  idx_t region ;   /**< index of the region  */
  int   area ;     /**< area of the region   */
#ifdef USE_RANK_UNION
  int   height ;    /**< node height         */
#endif
} node_t ;

/* extremal regions */
typedef struct
{
  idx_t parent ;     /**< parent region                           */
  idx_t index ;      /**< index of root pixel                     */
  val_t value ;      /**< value of root pixel                     */
  int   area ;       /**< area of the region                      */
  int   area_top ;   /**< area of the region DELTA levels above   */
  int   area_bot  ;  /**< area of the region DELTA levels below   */
  float variation ;  /**< variation                               */
  int   maxstable ;  /**< max stable number (=0 if not maxstable) */
} region_t ;

/* advance N-dimensional subscript */
void
adv(iArray *dims, int ndims, iArray *subs_pt)
{
    int d = 0 ;
    while(d < ndims) 
    {
        sref(subs_pt,d) = sref(subs_pt,d) + 1;
        if( sref(subs_pt,d)  < sref(dims,d) ) 
            return ;
        sref(subs_pt,d++) = 0 ;
    }
}

/** driver **/
I2D* mser(I2D* I, int in_delta)
{
   idx_t i, rindex=0;
   int k;
   int nout = 1;
   
   int OUT_REGIONS=0;
   int OUT_ELL = 1;
   int OUT_PARENTS = 2;
   int OUT_AREA = 3;
   int BUCKETS = 256;
   
   I2D* out;

   int IN_I = 0;
   int IN_DELTA = 1;   

    /* configuration */
    int verbose = 1 ;      /* be verbose                              */
    int small_cleanup= 1 ; /* remove very small regions               */
    int big_cleanup  = 1 ; /* remove very big regions                 */
    int bad_cleanup  = 0 ; /* remove very bad regions                 */
    int dup_cleanup  = 1 ; /* remove duplicates                       */
    val_t delta ;          /* stability delta                         */

    /* node value denoting a void node */
    idx_t const node_is_void = 0xffffffff ;

    iArray*   subs_pt ;       /* N-dimensional subscript                 */
    iArray*   nsubs_pt ;      /* diff-subscript to point to neigh.       */
    uiArray* strides_pt ;    /* strides to move in image array          */
    uiArray* visited_pt ;    /* flag                                    */

    int nel ;              /* number of image elements (pixels)       */
    int ner = 0 ;          /* number of extremal regions              */
    int nmer = 0 ;         /* number of maximally stable              */
    int ndims ;            /* number of dimensions                    */
    iArray* dims ;           /* dimensions                              */
    int njoins = 0 ;       /* number of join ops                      */

    I2D* I_pt ;    /* source image                            */
    pair_t*   pairs_pt ;   /* scratch buffer to sort pixels           */
    node_t*   forest_pt ;  /* the extremal regions forest             */
    region_t* regions_pt ; /* list of extremal regions found          */ 
    int regions_pt_size;
    int pairs_pt_size;
    int forest_pt_size;

    /* ellipses fitting */
    ulliArray* acc_pt ;        /* accumulator to integrate region moments */
    ulliArray* ell_pt ;        /* ellipses parameters                     */
    int    gdl ;           /* number of parameters of an ellipse      */
    uiArray* joins_pt ;      /* sequence of joins                       */
   
    delta = 0;
    delta = in_delta;

    /* get dimensions */

    nel = I->height*I->width;            /* number of elements of src image */
    ndims = 2;
    dims = malloc(sizeof(iArray) + sizeof(int)*ndims);
    I_pt = I;
    
    sref(dims,0) = I->height;
    sref(dims,1) = I->width;
    
    /* allocate stuff */
    subs_pt = malloc(sizeof(iArray) + sizeof(int)*ndims);
    nsubs_pt = malloc(sizeof(iArray) + sizeof(int)*ndims);

    strides_pt = malloc(sizeof(uiArray)+sizeof(unsigned int)*ndims);
    visited_pt = malloc(sizeof(uiArray) + sizeof(unsigned int)*nel);
    joins_pt = malloc(sizeof(uiArray) + sizeof(unsigned int)*nel);

    regions_pt = (region_t*)malloc(sizeof(region_t)*nel);
    regions_pt_size = nel;

    pairs_pt = (pair_t*)malloc(sizeof(pair_t)*nel);
    pairs_pt_size = nel;

    forest_pt = (node_t*)malloc(sizeof(node_t)*nel);
    forest_pt_size = nel;

    /* compute strides to move into the N-dimensional image array */
    sref(strides_pt,0) = 1;
    for(k = 1 ; k < ndims ; ++k)
    {
        sref(strides_pt,k) = sref(strides_pt,k-1) * sref(dims,k-1) ;
    }

    /* sort pixels in increasing order of intensity: using Bucket Sort */
    {
        int unsigned buckets [BUCKETS] ;
        memset(buckets, 0, sizeof(int unsigned)*BUCKETS) ;

        for(i = 0 ; i < nel ; ++i) 
        {
            val_t v = asubsref(I_pt,i) ;
            ++buckets[v] ;
        }
        
        for(i = 1 ; i < BUCKETS ; ++i) 
        {
            arrayref(buckets,i) += arrayref(buckets,i-1) ;
        }
        
        for(i = nel ; i >= 1 ; )
        {
            val_t v = asubsref(I_pt,--i) ;
            idx_t j = --buckets[v] ;
            pairs_pt[j].value = v ;
            pairs_pt[j].index = i ;
        }
    }
     
    /* initialize the forest with all void nodes */
    for(i = 0 ; i < nel ; ++i) 
    {
        forest_pt[i].parent = node_is_void  ;
    }
  
    /* number of ellipse free parameters */
    gdl = ndims*(ndims+1)/2 + ndims ;

    /* -----------------------------------------------------------------
    *                                     Compute extremal regions tree
    * -------------------------------------------------------------- */
  
    for(i = 0 ; i < nel ; ++i)
    {
        /* pop next node xi */
        idx_t index = pairs_pt [i].index ;    
        val_t value = pairs_pt [i].value ;

        /* this will be needed later */
        rindex = index ;
    
        /* push it into the tree */
        forest_pt [index] .parent   = index ;
        forest_pt [index] .shortcut = index ;
        forest_pt [index] .area     = 1 ;
#ifdef USE_RANK_UNION
        forest_pt [index] .height   = 1 ;
#endif
    
    /* convert index into a subscript sub; also initialize nsubs 
    to (-1,-1,...,-1) */
        {
            idx_t temp = index ;
            for(k = ndims-1 ; k >=0 ; --k) 
            {
                sref(nsubs_pt,k) = -1 ;
                sref(subs_pt,k) = temp / sref(strides_pt,k) ;
                temp         = temp % sref(strides_pt,k) ;
            }
        }
    
    /* process neighbors of xi */
        while(1) 
        {
            int good = 1 ;
            idx_t nindex = 0 ;
      
      /* compute NSUBS+SUB, the correspoinding neighbor index NINDEX
         and check that the pixel is within image boundaries. */
            for(k = 0 ; k < ndims && good ; ++k) 
            {
                int temp = sref(nsubs_pt,k) + sref(subs_pt,k) ;
                good &= 0 <= temp && temp < sref(dims,k) ;
                nindex += temp * sref(strides_pt,k) ;
            }      
      

      /* keep going only if
         1 - the neighbor is within image boundaries;
         2 - the neighbor is indeed different from the current node
             (this happens when nsub=(0,0,...,0));
         3 - the nieghbor is already in the tree, meaning that
             is a pixel older than xi.
      */
            if(good && nindex != index && forest_pt[nindex].parent != node_is_void ) 
            {
                idx_t nrindex = 0, nvisited ;
                val_t nrvalue = 0 ;
                

#ifdef USE_RANK_UNION
                int height  = forest_pt [ rindex] .height ;
                int nheight = forest_pt [nrindex] .height ;
#endif
        
        /* RINDEX = ROOT(INDEX) might change as we merge trees, so we
           need to update it after each merge */
        
        /* find the root of the current node */
        /* also update the shortcuts */
                nvisited = 0 ;
                while( forest_pt[rindex].shortcut != rindex ) 
                {          
                    sref(visited_pt,nvisited++) = rindex ;
                    rindex = forest_pt[rindex].shortcut ;
                }      
                while( nvisited-- ) 
                {
                    forest_pt [ sref(visited_pt,nvisited) ] .shortcut = rindex ;
                }
        
        /* find the root of the neighbor */
                nrindex  = nindex ;
                nvisited = 0 ;
                while( forest_pt[nrindex].shortcut != nrindex ) 
                {          
                    sref(visited_pt, nvisited++) = nrindex ;
                    nrindex = forest_pt[nrindex].shortcut ;
                }      
                while( nvisited-- ) 
                {
                    forest_pt [ sref(visited_pt,nvisited) ] .shortcut = nrindex ;
                }
        
        /*
          Now we join the two subtrees rooted at
          
            RINDEX = ROOT(INDEX) and NRINDEX = ROOT(NINDEX).
          
          Only three things can happen:
          
          a - ROOT(INDEX) == ROOT(NRINDEX). In this case the two trees
              have already been joined and we do not do anything.
          
          b - I(ROOT(INDEX)) == I(ROOT(NRINDEX)). In this case index
              is extending an extremal region with the same
              value. Since ROOT(NRINDEX) will NOT be an extremal
              region of the full image, ROOT(INDEX) can be safely
              addedd as children of ROOT(NRINDEX) if this reduces
              the height according to union rank.
               
          c - I(ROOT(INDEX)) > I(ROOT(NRINDEX)) as index is extending
              an extremal region, but increasing its level. In this
              case ROOT(NRINDEX) WILL be an extremal region of the
              final image and the only possibility is to add
              ROOT(NRINDEX) as children of ROOT(INDEX).
        */

                if( rindex != nrindex ) 
                {
                    /* this is a genuine join */
          
                    nrvalue = asubsref(I_pt,nrindex) ;
                    if( nrvalue == value 
#ifdef USE_RANK_UNION             
              && height < nheight
#endif
                    ) 
                    {
                        /* ROOT(INDEX) becomes the child */
                        forest_pt[rindex] .parent   = nrindex ;
                        forest_pt[rindex] .shortcut = nrindex ;          
                        forest_pt[nrindex].area    += forest_pt[rindex].area ;

#ifdef USE_RANK_UNION
                        forest_pt[nrindex].height = MAX(nheight, height+1) ;
#endif

                        sref(joins_pt,njoins++) = rindex ;

                    } 
                    else 
                    {
                        /* ROOT(index) becomes parent */
                        forest_pt[nrindex] .parent   = rindex ;
                        forest_pt[nrindex] .shortcut = rindex ;
                        forest_pt[rindex]  .area    += forest_pt[nrindex].area ;

#ifdef USE_RANK_UNION
                        forest_pt[rindex].height = MAX(height, nheight+1) ;
#endif
                        if( nrvalue != value ) 
                        {            
                            /* nrindex is extremal region: save for later */
                            forest_pt[nrindex].region = ner ;
                            regions_pt [ner] .index      = nrindex ;
                            regions_pt [ner] .parent     = ner ;
                            regions_pt [ner] .value      = nrvalue ;
                            regions_pt [ner] .area       = forest_pt [nrindex].area ;
                            regions_pt [ner] .area_top   = nel ;
                            regions_pt [ner] .area_bot   = 0 ;            
                            ++ner ;
                        }
            
                        /* annote join operation for post-processing */
                        sref(joins_pt,njoins++) = nrindex ;
                    }
                }
        
            } /* neighbor done */
      
            /* move to next neighbor */      
            k = 0 ;
            sref(nsubs_pt,k) = sref(nsubs_pt,k) + 1;
            while( sref(nsubs_pt, k) > 1) 
            {
                sref(nsubs_pt,k++) = -1 ;
                if(k == ndims) goto done_all_neighbors ;
                sref(nsubs_pt,k) = sref(nsubs_pt,k) + 1;
            }
        } /* next neighbor */
        done_all_neighbors : ;
    } /* next pixel */    
    
 
    /* the root of the last processed pixel must be a region */
    forest_pt [rindex].region = ner ;
    regions_pt [ner] .index      = rindex ;
    regions_pt [ner] .parent     = ner ;
    regions_pt [ner] .value      = asubsref(I_pt,rindex) ;
    regions_pt [ner] .area       = forest_pt [rindex] .area ;
    regions_pt [ner] .area_top   = nel ;
    regions_pt [ner] .area_bot   = 0 ;            
    ++ner ;
    
    /* -----------------------------------------------------------------
    *                                            Compute region parents
    * -------------------------------------------------------------- */
    for( i = 0 ; i < ner ; ++i) 
    {
        idx_t index  = regions_pt [i].index ;    
        val_t value  = regions_pt [i].value ;
        idx_t j      = i ;

        while(j == i) 
        {
            idx_t pindex = forest_pt [index].parent ;
            val_t pvalue = asubsref(I_pt,pindex) ;

            /* top of the tree */
            if(index == pindex) 
            {
                j = forest_pt[index].region ;
                break ;
            }

            /* if index is the root of a region, either this is still
            i, or it is the parent region we are looking for. */
            if(value < pvalue) 
            {
                j = forest_pt[index].region ;
            }

            index = pindex ;
            value = pvalue ;
        }
        regions_pt[i]. parent = j ;
    }
  
    /* -----------------------------------------------------------------
    *                                 Compute areas of tops and bottoms
    * -------------------------------------------------------------- */

    /* We scan the list of regions from the bottom. Let x0 be the current
     region and be x1 = PARENT(x0), x2 = PARENT(x1) and so on.
     
     Here we do two things:
     
     1) Look for regions x for which x0 is the BOTTOM. This requires
        VAL(x0) <= VAL(x) - DELTA < VAL(x1).
        We update AREA_BOT(x) for each of such x found.
        
     2) Look for the region y which is the TOP of x0. This requires
          VAL(y) <= VAL(x0) + DELTA < VAL(y+1)
          We update AREA_TOP(x0) as soon as we find such y.
        
    */

    for( i = 0 ; i < ner ; ++i) 
    {
        /* fix xi as the region, then xj are the parents */
        idx_t parent = regions_pt [i].parent ;
        int   val0   = regions_pt [i].value ;
        int   val1   = regions_pt [parent].value ;
        int   val    = val0 ;
        idx_t j = i ;

        while(1) 
        {
            int valp = regions_pt [parent].value ;

            /* i is the bottom of j */
            if(val0 <= val - delta && val - delta < val1) 
            {
                regions_pt [j].area_bot  =
                MAX(regions_pt [j].area_bot, regions_pt [i].area) ;
            }
      
            /* j is the top of i */
            if(val <= val0 + delta && val0 + delta < valp) 
            {
                regions_pt [i].area_top = regions_pt [j].area ;
            }
      
            /* stop if going on is useless */
            if(val1 <= val - delta && val0 + delta < val)
                break ;

            /* stop also if j is the root */
            if(j == parent)
                break ;
      
            /* next region upward */
            j      = parent ;
            parent = regions_pt [j].parent ;
            val    = valp ;
        }
    }

    /* -----------------------------------------------------------------
    *                                                 Compute variation
    * -------------------------------------------------------------- */
    for(i = 0 ; i < ner ; ++i) 
    {
        int area     = regions_pt [i].area ;
        int area_top = regions_pt [i].area_top ;
        int area_bot = regions_pt [i].area_bot ;    
        regions_pt [i].variation = (area_top - area_bot) / (area*1.0) ;

        /* initialize .mastable to 1 for all nodes */
        regions_pt [i].maxstable = 1 ;
    }

    /* -----------------------------------------------------------------
    *                     Remove regions which are NOT maximally stable
    * -------------------------------------------------------------- */
    nmer = ner ;
    for(i = 0 ; i < ner ; ++i) 
    {
        idx_t parent = regions_pt [i]      .parent ;
        float var    = regions_pt [i]      .variation ;
        float pvar   = regions_pt [parent] .variation ;
        idx_t loser ;

        /* decide which one to keep and put that in loser */
        if(var < pvar) loser = parent ; else loser = i ;
    
        /* make loser NON maximally stable */
        if(regions_pt [loser].maxstable) --nmer ;
        regions_pt [loser].maxstable = 0 ;
    }


    /* -----------------------------------------------------------------
    *                                               Remove more regions
    * -------------------------------------------------------------- */

    /* it is critical for correct duplicate detection to remove regions
     from the bottom (smallest one first) */

    if( big_cleanup || small_cleanup || bad_cleanup || dup_cleanup ) 
    {
        int nbig   = 0 ;
        int nsmall = 0 ;
        int nbad   = 0 ;
        int ndup   = 0 ;

        /* scann all extremal regions */
        for(i = 0 ; i < ner ; ++i) 
        {
      
            /* process only maximally stable extremal regions */
            if(! regions_pt [i].maxstable) continue ;
      
            if( bad_cleanup   && regions_pt[i].variation >= 1.0f  ) 
            {
                ++nbad ;
                goto remove_this_region ;
            }

            if( big_cleanup   && regions_pt[i].area  >  nel/2 ) 
            {
                ++nbig ;
                goto remove_this_region ;
            }

            if( small_cleanup && regions_pt[i].area      <  25    ) 
            {
                ++nsmall ;
                goto remove_this_region ;
            }
      
            /** Remove duplicates */

            if( dup_cleanup ) 
            {
                idx_t parent = regions_pt [i].parent ;
                int area, parea ;
                float change ;
        
                /* the search does not apply to root regions */
                if(parent != i) 
                {
          
                    /* search for the maximally stable parent region */
                    while(! regions_pt[parent].maxstable) 
                    {
                        idx_t next = regions_pt[parent].parent ;
                        if(next == parent) break ;
                        parent = next ;
                    }
          
                    /* compare with the parent region; if the current and parent
                    regions are too similar, keep only the parent */
          
                    area   = regions_pt [i].area ;
                    parea  = regions_pt [parent].area ;
                    change = (parea - area)/(area*1.0) ;

                    if(change < 0.5)  
                    {
                        ++ndup ;
                        goto remove_this_region ;
                    }

                } /* drop duplicates */ 
            }
      
            continue ;
            remove_this_region :
            regions_pt[i].maxstable = 0 ;
            --nmer ;
                  
        } /* next region to cleanup */

        if(0) 
        {
            printf("  Bad regions:        %d\n", nbad   ) ;
            printf("  Small regions:      %d\n", nsmall ) ;
            printf("  Big regions:        %d\n", nbig   ) ;
            printf("  Duplicated regions: %d\n", ndup   ) ;
        }
    }

/*    printf("Cleaned-up regions: %d (%.1f%%)\n", 
                       nmer, 100.0 * (double) nmer / ner) ;
*/
    /* -----------------------------------------------------------------
    *                                                      Fit ellipses
    * -------------------------------------------------------------- */
    ell_pt = 0 ;
    if (nout >= 1) 
    {
        int midx = 1 ;
        int d, index, j ;
    
        /* enumerate maxstable regions */
        for(i = 0 ; i < ner ; ++i) 
        {      
            if(! regions_pt [i].maxstable) continue ;
            regions_pt [i].maxstable = midx++ ;
        }
    
        /* allocate space */
        acc_pt = malloc(sizeof(ulliArray) + sizeof(acc_t)*nel) ;
        ell_pt = malloc(sizeof(ulliArray) + sizeof(acc_t)*gdl*nmer) ; 
   
        /* clear accumulators */
        for(d=0; d<(gdl*nmer); d++)
            sref(ell_pt,d) = 0;
    
        /* for each gdl */
        for(d = 0 ; d < gdl ; ++d) 
        {
            /* initalize parameter */
            int counter_i;
            for(counter_i=0; counter_i<ndims; counter_i++)
                sref(subs_pt,counter_i) = 0;
      
            if(d < ndims) 
            {
                for(index = 0 ; index < nel ; ++ index) 
                {
                    sref(acc_pt,index) = sref(subs_pt,d) ;
                    adv(dims, ndims, subs_pt) ;
                }
            } 
            else 
            {
                /* decode d-ndims into a (i,j) pair */
                i = d-ndims ; 
                j = 0 ;
                while(i > j) 
                {
                    i -= j + 1 ;
                    j ++ ;
                }

                /* add x_i * x_j */
                for(index = 0 ; index < nel ; ++ index)
                {
                    sref(acc_pt,index) = sref(subs_pt,i) * sref(subs_pt,j) ;
                    adv(dims, ndims, subs_pt) ;
                }
            }

            /* integrate parameter */
            for(i = 0 ; i < njoins ; ++i) 
            {      
                idx_t index  = sref(joins_pt,i);
                idx_t parent = forest_pt [ index ].parent ;
                sref(acc_pt,parent) += sref(acc_pt,index) ;
            }
    
            /* save back to ellpises */
            for(i = 0 ; i < ner ; ++i) 
            {
                idx_t region = regions_pt [i].maxstable ;

                /* skip if not extremal region */
                if(region-- == 0) continue ;
                sref(ell_pt,d + gdl*region) = sref(acc_pt, regions_pt[i].index) ;
            }

            /* next gdl */
        }
        free(acc_pt) ;
        free(ell_pt) ;
    }
  
    /* -----------------------------------------------------------------
    *                                                Save back and exit
    * -------------------------------------------------------------- */

    /*
    * Save extremal regions
    */
    {
        int dims[2], j=0;
        I2D* pt ;
        dims[0] = nmer ;
        out = iMallocHandle(1, nmer);
        pt = out;
        for (i = 0 ; i < ner ; ++i) 
        {
            if( regions_pt[i].maxstable ) 
            {
                /* adjust for MATLAB index compatibility */
//                *pt++ = regions_pt[i].index + 1 ;
                asubsref(pt,j++) = regions_pt[i].index + 1 ;
            }
        }
    }

    /* free stuff */
    free(dims);
    free( forest_pt  ) ;
    free( pairs_pt   ) ;
    free( regions_pt ) ;
    free( visited_pt ) ;
    free( strides_pt ) ;
    free( nsubs_pt   ) ;
    free( subs_pt    ) ;
    free( joins_pt    ) ;

    return out;
}



