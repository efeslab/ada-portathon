function [doogs,index] = mkdoogs(sigma_w,r,theta,theta_to,size_w)
%  function doogs = mkdoogs(sigma_w,r,theta,theta_to,size_w)
% 

doogs = [];

angle_start = theta*pi/180;
angle_end = theta_to*pi/180;
step = pi/180;

index = 1;
for k=angle_start:step:angle_end,
  doogs = [doogs,mkdoog2(sigma_w,r,k,size_w)];
  index = index +1;
end
