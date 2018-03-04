function script_run_profile(dataDir, resultDir, type, common, tooldir)

path(path,common); 
sift_compile;

I1=readImage([dataDir, '/1.bmp']) ; 

rows = size(I1,1);
cols = size(I1,2);
fprintf(1,'Input size\t\t- (%dx%d)\n', rows, cols);

I1=I1-min(I1(:)) ;
I1=I1/max(I1(:)) ;

%% Timing
start = photonStartTiming;
frames1 = sift( I1) ;
stop = photonEndTiming;
elapsed = photonReportTiming(start, stop);
photonPrintTiming(elapsed);

fWriteMatrix(frames1, dataDir);

