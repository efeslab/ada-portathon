% MNcutDemo.m
% created by song, 06/13/2005
%  an exmaple of how to use and display MNcut


function script_run_profile(dataDir, resultDir, type, common, toolDir)

%% Input parameters

if(nargin == 0)
    data_set='test';    
end
if(nargin <=2)
    imageSize = 100;
end

num_segs = 20;
if(strcmp(type, 'test'))
    num_segs = 1;
elseif(strcmp(type, 'sim_fast'))
    num_segs = 1;
elseif(strcmp(type, 'sim'))
    num_segs = 2;
elseif(strcmp(type, 'sqcif'))
    num_segs = 3;
elseif(strcmp(type, 'qcif'))
    num_segs = 4;
elseif(strcmp(type, 'cif'))
    num_segs = 8;
elseif(strcmp(type, 'vga'))
    num_segs = 13;
elseif(strcmp(type, 'wuxga'))
    num_segs = 32;
end

path(path, [toolDir,'/MultiNcut']);
path(path, common);

img_filename = [dataDir, '/1.bmp'];
%I=imread(img_filename);
%I = rgb2gray(I);

I = readImage(img_filename);

%% Self check params
tol = 0.1;
elapsed = zeros(1,2);
rows = size(I,1);
cols = size(I,2);    
fprintf(1,'Input size\t\t- (%dx%d)\n', rows, cols);

%% Timing
start = photonStartTiming;

[SegLabel,eigenVectors,eigenValues]= MNcut(I,num_segs);

%% Timing
stop = photonEndTiming;
    
temp = photonReportTiming(start, stop);
elapsed(1) = elapsed(1) + temp(1);
elapsed(2) = elapsed(2) + temp(2);

%% Self checking
writeMatrix(SegLabel, dataDir);

%% Timing
photonPrintTiming(elapsed);

for j=1:size(SegLabel,3),
   [gx,gy] = gradient(SegLabel(:,:,j));
   bw = (abs(gx)>0.1) + (abs(gy) > 0.1);

   figure(1);clf; J1=showmask(double(I),bw); imagesc(J1);axis image; axis off;
   set(gca, 'Position', [0 0 1 1]);
end


