function [edgemap,mag,th] = find_edge(I,sig,mag_thld)
%
% [edgemap,mag,th] = find_edge(I,sig,mag_thld)
%

if nargin<2,
  sig = 1;
end

if nargin<3,
  mag_thld = 1/30;
end

I = I/max(I(:));

ismax = 1;r = 1;

[gx,gy] = grad(I,sig);
[th,mag] = cart2pol(gy,gx);

g = cat(3,gy,gx);
edgemap = nonmaxsup(g,ismax,r);
edgemap = edgemap.*(mag>mag_thld);

