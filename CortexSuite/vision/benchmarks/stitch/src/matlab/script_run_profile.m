function script_run_profile(dataDir, resultDir, type, common, toolDir)

path(path, common);
image_list = 1;

elapsed = zeros(1,2);
for i=1:image_list
    Icur = readImage([dataDir, '/', num2str(i) ,'.bmp']);
	rows = size(Icur,1);
	cols = size(Icur,2);    
	fprintf(1,'Input size\t\t- (%dx%d)\n', rows, cols);

    %% Self check params
    tol = 1;

    %% Timing
    start = photonStartTiming;
    
    [x y v]=harris(Icur,dataDir);
    interestPntsCur=getANMS(x, y, v, 24, dataDir);
    Fcur=extractFeatures(Icur, interestPntsCur(:,1), interestPntsCur(:,2), dataDir);
    
    %% Timing
    stop = photonEndTiming;

    temp = photonReportTiming(start, stop);
    elapsed(1) = elapsed(1) + temp(1);
    elapsed(2) = elapsed(2) + temp(2);


end

%% Self checking
fWriteMatrix(Fcur, dataDir);

%% Timing
photonPrintTiming(elapsed);

