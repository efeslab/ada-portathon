function [xn] = normalize(x_kk,fc,cc,kc),

%normalize
%
%[xn] = normalize(x_kk,fc,cc,kc)
%
%Computes the normalized coordinates xn given the pixel coordinates x_kk
%and the intrinsic camera parameters fc, cc and kc.
%
%INPUT: x_kk: Feature locations on the images
%       fc: Camera focal length
%       cc: Principal point coordinates
%       kc: Distortion coefficients
%
%OUTPUT: xn: Normalized feature locations on the image plane (a 2XN matrix)
%
%Important functions called within that program:
%
%comp_distortion_oulu: undistort pixel coordinates.



% First subtract principal point, and divide by the focal length:

x_distort = [(x_kk(1,:) - cc(1))/fc(1);(x_kk(2,:) - cc(2))/fc(2)];


%Compensate for lens distortion:

xn = comp_distortion_oulu(x_distort,kc);


