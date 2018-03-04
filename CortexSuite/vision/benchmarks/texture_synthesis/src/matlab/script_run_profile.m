% Example 2:  Seamless blending of real and synthetic texture in an
% image, using Portilla-Simoncelli texture analysis/synthesis code,
% based on alternate projections onto statistical constraints in a
% complex overcomplete wavelet representation.
%
% See Readme.txt, and headers of textureAnalysis.m and
% textureSynthesis.m for more details.
%
% Javier Portilla (javier@decsai.ugr.es).  March, 2001

function script_run_profile(dataDir, resultDir, type, common,toolDir)

path(path, common);
Files = dir([dataDir,'/1.bmp']);
inputFile = fullfile(dataDir,Files(1).name);

close all

Nsc = 4; % Number of scales
Nor = 4; % Number of orientations
Na = 5;  % Spatial neighborhood is Na x Na coefficients
			% It must be an odd number!
Niter = 25;	% Number of iterations of synthesis loop
Nsx = 192;	% Size of synthetic image is Nsy x Nsx
Nsy = 192;	% Warning: both dimensions must be multiple of 2^(Nsc+2)

if(strcmp(type,'qcif'))
Nsc = 4;
Nor = 4;
Na = 5;
Niter = 5;
elseif(strcmp(type,'sqcif'))
Nsc = 2;
Nor = 2;
Na = 3;
Niter = 5;
elseif(strcmp(type, 'test'))
Nsc = 2; % Number of scales
Nor = 2; % Number of orientations
Na = 1;  % Spatial neighborhood is Na x Na coefficients
			% It must be an odd number!
Niter = 1;	% Number of iterations of synthesis loop
Nsx = 16;	% Size of synthetic image is Nsy x Nsx
Nsy = 16;	% Warning: both dimensions must be multiple of 2^(Nsc+2)

elseif(strcmp(type, 'sim_fast'))
Nsc = 2; % Number of scales
Nor = 2; % Number of orientations
Na = 3;  % Spatial neighborhood is Na x Na coefficients
			% It must be an odd number!
Niter = 2;	% Number of iterations of synthesis loop
Nsx = 16;	% Size of synthetic image is Nsy x Nsx
Nsy = 16;	% Warning: both dimensions must be multiple of 2^(Nsc+2)

elseif(strcmp(type, 'sim'))
Nsc = 2; % Number of scales
Nor = 2; % Number of orientations
Na = 3;  % Spatial neighborhood is Na x Na coefficients
			% It must be an odd number!
Niter = 1;	% Number of iterations of synthesis loop
Nsx = 32;	% Size of synthetic image is Nsy x Nsx
Nsy = 32;	% Warning: both dimensions must be multiple of 2^(Nsc+2)

elseif(strcmp(type, 'vga'))
Nsc = 2; % Number of scales
Nor = 2; % Number of orientations
Na = 3;  % Spatial neighborhood is Na x Na coefficients
			% It must be an odd number!
Niter = 1;	% Number of iterations of synthesis loop
Nsx = 640;	% Size of synthetic image is Nsy x Nsx
Nsy = 480;	% Warning: both dimensions must be multiple of 2^(Nsc+2)

elseif(strcmp(type, 'real'))
Nsc = 2; % Number of scales
Nor = 2; % Number of orientations
Na = 3;  % Spatial neighborhood is Na x Na coefficients
			% It must be an odd number!
Niter = 1;	% Number of iterations of synthesis loop
Nsx = 1920;	% Size of synthetic image is Nsy x Nsx
Nsy = 1200;	% Warning: both dimensions must be multiple of 2^(Nsc+2)

end

im0 = readImage(inputFile);	% Warning: im0 is a double float matrix!
rows = size(im0,1);
cols = size(im0,2);
fprintf(1,'Input size\t\t- (%dx%d)\n', rows, cols);

%% Self check params
tol = 0.1;
elapsed = zeros(1,2);

%% Timing
start = photonStartTiming;

params = textureAnalysis(im0, Nsc, Nor, Na);

%% Timing
stop = photonEndTiming;

temp = photonReportTiming(start, stop);
elapsed(1) = elapsed(1) + temp(1);
elapsed(2) = elapsed(2) + temp(2);

% Use a mask and the original image to synthesize an image with the
% left side synthetic and the right side real data.
% The effective mask is M = (mask>0), its smoothness is for avoiding
% border effects.
ramp = meshgrid(1:Nsx/4,1:Nsy)*4/Nsy;
mask = [zeros(Nsy,Nsx/2) ramp ramp(:,Nsx/4:-1:1)];
mask =  1/2*(1-cos(pi*mask));

imKeep = zeros(Nsx*Nsy,2);
imKeep(:,1) = reshape(mask, [Nsy*Nsx,1]);
imKeep(:,2) = reshape(im0(1:Nsy,1:Nsx), [Nsy*Nsx,1]);	% Original

%% Timing
start = photonStartTiming;

res = textureSynthesis(params, [Nsy Nsx], Niter,[],imKeep);

%% Timing
stop = photonEndTiming;

temp = photonReportTiming(start, stop);
elapsed(1) = elapsed(1) + temp(1);
elapsed(2) = elapsed(2) + temp(2);

%% Self checking
fWriteMatrix(res, dataDir);

rows = Nsy;
cols = Nsx;

%% Timing
photonPrintTiming(elapsed);

%close all
%figure(1);showIm(mask>0, 'auto', 'auto', 'Mask');
%figure(2);showIm(im0, 'auto', 'auto', 'Original Texture');
%figure(3);showIm(res, 'auto', 'auto', 'Blended Original and Synthetic Texture');
%pause;
