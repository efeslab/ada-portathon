#define MAX_LENGTH 1024

#include "helper/pocketsphinx.h"

int
main(int argc, char *argv[])
{
    //** Timing**// 
    unsigned int* start, *stop, *elapsed;
    
    char model1[MAX_LENGTH];
    char model2[MAX_LENGTH];
    char model3[MAX_LENGTH];
    strcpy(model1, argv[2]);
    strcpy(model2, argv[2]);
    strcpy(model3, argv[2]);
    
    strcat(model1, "model");
    strcat(model2, "model.DMP");
    strcat(model3, "model.dict");
    
    ps_decoder_t *ps;
    cmd_ln_t *config;
    FILE *fh;
    char const *hyp, *uttid;
    int16 buf[512];
    int rv;
    int32 score;
    
    config = cmd_ln_init(NULL, ps_args(), TRUE, "-hmm", model1, "-lm", model2, "-dict", model3, NULL);
    if (config == NULL)
        return 1;
    ps = ps_init(config);
    if (ps == NULL)
        return 1;
    
    fh = fopen(argv[1], "rb");
    if (fh == NULL) {
        perror("Failed to open the audio file");
        return 1;
    }
    
    start = photonStartTiming(); 
    rv = ps_decode_raw(ps, fh, "newsound", -1);
    if (rv < 0)
        return 1;
    hyp = ps_get_hyp(ps, &score, &uttid);
    if (hyp == NULL)
        return 1;
   stop = photonEndTiming(); 
    fclose(fh);
    
    fh = fopen ("out.txt", "wt");
    fprintf(fh, "%s", hyp);
    fclose(fh);
    elapsed = photonReportTiming(start,stop);
    photonPrintTiming(elapsed);
    
   // ps_free(ps);
   // fclose(fh);
    return 0;
}
