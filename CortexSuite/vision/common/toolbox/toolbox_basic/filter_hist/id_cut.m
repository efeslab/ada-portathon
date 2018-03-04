function [x,map] = idcut(data,cmap,nbin)
%
%
%

lc = size(cmap,1);

data = data - min(data);
data = 1+ ((lc-1)*data/max(data));

r = cmap(data,1);g = cmap(data,2);b = cmap(data,3);

[x,map] = vmquant(r,g,b,nbin);

