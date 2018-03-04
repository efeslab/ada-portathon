function [motion] = MotionEstimation(I1, I2)
%Load Images
REF = im2double(rgb2gray(imread(I1)));
IM = im2double(rgb2gray(imread(I2)));

%Find the size of Center Image
%[row, col] = size(REF);
REF_INTERP = interp2(REF, 4);
[row, col] = size(REF_INTERP);
IM_INTERP = interp2(IM, 4);
[row1, col1] = size(REF_INTERP);
%ZI = REF_INTERP(row1/2-50:row1/2+50, col1/2-50:col1/2+50);
hbm = vision.BlockMatcher( ...
 		'ReferenceFrameSource','Input port','BlockSize',[35 35]);
hbm.OutputValue = ...
 		'Horizontal and vertical components in complex form';

%Find template location in the Border Image
motion = step(hbm, REF_INTERP, IM_INTERP);
%motion = [double((Loc(1,1)-(row/2))/4), double((Loc(1,2)-(col/2))/4)];

