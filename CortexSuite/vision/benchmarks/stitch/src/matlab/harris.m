
% Sample code for detecting Harris corners, following 
% Brown et al, CVPR 2005
%        by Alyosha Efros, so probably buggy...

function [x,y,v] = harris(im, dataDir);

g1 = [1,4,6,4,1; 4,16,24,16,4;6,24,36,24,6;4,16,24,16,4;1,4,6,4,1]/256;
g2 = [1,2,1;2,4,2;1,2,1]/16;

img1 = conv2(im,g1,'same');  % blur image with sigma_d
     
Ix = conv2(img1,[-0.5 0 0.5],'same');  % take x derivative 
Iy = conv2(img1,[-0.5;0;0.5],'same');  % take y derivative

% Compute elements of the Harris matrix H
%%% we can use blur instead of the summing window
Ix2 = conv2(Ix.*Ix,g2,'same');
Iy2 = conv2(Iy.*Iy,g2,'same');
IxIy = conv2(Ix.*Iy,g2,'same'); 

R = (Ix2.*Iy2 - IxIy.*IxIy) ... % det(H) 
    ./ (Ix2 + Iy2 + eps);       % trace(H) + epsilon

% don't want corners close to image border
[rows, cols] = size(im);

% non-maxima supression within 3x3 windows
nonmax = inline('max(x)');
Rmax = colfilt(R,[3 3],'sliding',nonmax); % find neighbrhood max
Rnm = R.*(R == Rmax);  % supress non-max

% extract all interest points
[y,x,v] = find(Rnm);



