#ifndef _PHOTON_TIMING_H
#define _PHOTON_TIMING_H

// Timing routines

extern unsigned int * photonStartTiming();
extern unsigned int * photonReportTiming(unsigned int* startCycles,unsigned int* endCycles);
extern void photonPrintTiming(unsigned int * elapsed);
extern unsigned int * photonEndTiming();

#endif // _PHOTON_TIMING_H
