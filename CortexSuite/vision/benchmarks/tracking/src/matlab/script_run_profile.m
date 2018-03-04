function script_run_profile(dataDir, resultDir, type, common, toolDir)

if(~isdeployed)
    addpath(fullfile(toolDir, '/lagrcv/'));
    addpath(fullfile(toolDir, '/toolbox_basic/filter/'));
    addpath(fullfile(toolDir, '/ikkjin/'));
end
IMAGE_DIR=dataDir;

path(path,common); 

tol = 2;

%% Input params
N_FEA=1600;
WINSZ=4; %size of sum-up window
NO_PYR=2;
SUPPRESION_RADIUS=10;
LK_ITER=20;
counter = 2;
accuracy = 0.03;

if(strcmp(type,'test'))
    WINSZ = 2;
    N_FEA = 10;
    LK_ITER = 2;
    counter = 2;
    accuracy = 0.1;
elseif(strcmp(type, 'sim_fast'))
    WINSZ = 2;
    N_FEA = 100;
    LK_ITER = 2;
    counter = 4;
elseif(strcmp(type,'sim'))
    WINSZ = 2;
    N_FEA = 200;
    LK_ITER = 2;
    counter = 4;
elseif(strcmp(type,'sqcif'))
    WINSZ = 8;
    N_FEA = 500;
    LK_ITER = 15;
    counter = 2;
elseif(strcmp(type, 'qcif'))
    WINSZ = 12;
    N_FEA = 400;
    LK_ITER = 15;
    counter = 4;
elseif(strcmp(type,'cif'))
    WINSZ = 20;
    N_FEA = 500;
    LK_ITER = 20;
    counter = 4;
elseif(strcmp(type, 'vga'))
    WINSZ = 32;
    N_FEA = 400;
    LK_ITER = 20;
    counter = 4;
elseif(strcmp(type,'fullhd'))
    WINSZ = 48;
    N_FEA = 500;
    LK_ITER = 20;
    counter = 4;
elseif(strcmp(type,'wuxga'))
    WINSZ = 64;
    N_FEA = 500;
    LK_ITER = 20;
    counter = 4;
end

imgName = [dataDir, '/1.bmp'];
Icur=readImage(imgName);

[rows,cols] = size(Icur);
fprintf(1,'Input size\t\t- (%dx%d)\n', rows, cols);

%% Timing
start = photonStartTiming;

Icur = imageBlur(double(Icur));

 Jpyr = cell(2,1);
 Jpyr{1} = Icur;
 Jpyr{2} = imageResize(Icur);

 [dX, dY] = calcSobel(double(Icur));
 sizeWin = size(dX);
 [lambda, tr, det, c_xx, c_xy, c_yy] = calcGoodFeature(dX, dY, sizeWin(2), sizeWin(1), WINSZ, dataDir);

imgsz=size(lambda);
lambda([1:WINSZ,end-WINSZ:end],:)=0;
lambda(:,[1:WINSZ,end-WINSZ:end])=0;

[temp,idx]=sort(lambda(:), 'descend');
featureIdx=idx(1:N_FEA);
features=zeros(3, N_FEA);
features(1,:)=ceil(featureIdx/imgsz(1));

fIdxT = featureIdx';
features(2,:)=fIdxT-(features(1,:)-1)*imgsz(1);
features(3,:)=lambda(featureIdx);

for i=1:N_FEA
    features(3,i) = lambda(idx(i));
end

f1T = features(1,:)';
f2T = features(2,:)';
f3T = features(3,:)';

interestPnt=getANMS(f1T, f2T, f3T, SUPPRESION_RADIUS, dataDir);

interestPnt=interestPnt';
features=interestPnt(1:2,:);
    
%% Timing
endC = photonEndTiming;
elapsed = photonReportTiming(start, endC);

for iter=1:counter
    imgName = [dataDir, '/', num2str(iter),  '.bmp'];
    Iprev=Icur;
    Icur=readImage(imgName);
    
    %% Self check params
    tol = 0.1;
    %% Timing
    start = photonStartTiming;

    Icur = imageBlur(double(Icur));
    
    Ipyr=Jpyr;
    
    Jpyr = cell(2,1);
    Jpyr{1} = Icur;
    Jpyr{2} = imageResize(Icur);

    dxPyr = cell(2,1);
    dyPyr = cell(2,1);
     
    [dxPyr{1}, dyPyr{1}] = calcSobel(Jpyr{1});
    [dxPyr{2}, dyPyr{2}] = calcSobel(Jpyr{2});
    
    sizeWin = size(dxPyr{2});
    nFeatures = size(features);
     
    [newpoints, currStatus] = calcPyrLKTrack(Ipyr, dxPyr, dyPyr, Jpyr, double(features), nFeatures(2), WINSZ, 0.03, LK_ITER);
    
    newpoints=newpoints(:,find(currStatus));

    %% Timing
    stop = photonEndTiming;

    temp = photonReportTiming(start, stop);
    elapsed(1) = elapsed(1) + temp(1);
    elapsed(2) = elapsed(2) + temp(2);

%      figure(1);
%      imagesc(Icur);colormap gray
%      hold on;
%      scatter(newpoints(1,:), newpoints(2,:), 'r+');
%      hold off;    
%      drawnow
%     
    features=newpoints;

end
    
%% Self checking
fWriteMatrix(features, dataDir);

photonPrintTiming(elapsed);

if(~isdeployed)
    rmpath(fullfile(toolDir, '/lagrcv/'));
    rmpath(fullfile(toolDir, '/toolbox_basic/filter/'));
    rmpath(fullfile(toolDir, '/ikkjin/'));
end
