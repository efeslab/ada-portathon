function script_run_profile(dataDir, resultDir, type, common, tooldir)

path(path,common); 

tol = 2;
elapsed = [0, 0];

WIN_SZ = 8;
SHIFT = 64;

if(strcmp(type,'test'))
    WIN_SZ = 2;
    SHIFT = 1;
elseif(strcmp(type, 'sim_fast'))
    WIN_SZ = 4;
    SHIFT = 4;
elseif(strcmp(type,'sim'))
    WIN_SZ = 4;
    SHIFT = 8;
end

    outFile = [resultDir, '/', 'out', '.bmp'];

    file = [dataDir, '/1.bmp'];
    imleft = readImage(file);
    imright = readImage([dataDir, '/2.bmp']);
    [rows, cols] = size(imright);

    fprintf(1,'Input size\t\t- (%dx%d)\n', rows, cols);

    start = photonStartTiming;
    [imDispOwn, DispSAD, minSAD]=getDisparity(double(imleft), double(imright), WIN_SZ, SHIFT);
    stop = photonEndTiming;
    elapsed = photonReportTiming(start, stop);

    writeMatrix(imDispOwn, dataDir);
    imwrite(uint8(minSAD), outFile, 'bmp');

    photonPrintTiming(elapsed);




