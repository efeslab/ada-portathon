function [vbig,bnr,bnc] = proj_back_id(v,gcs,gce,grs,gre)
%
%   vbig = proj_back_id(v,gcs,gce,grs,gre)
%

nr = max(gre)+1;
nc = max(gce)+1;

sw = 3;
gap = 2*sw+1;

bnc = nc*gap;
bnr = nr*gap;

[x,y] = meshgrid(1:bnc,1:bnr);

idx = grs(y(:))+1+gcs(x(:))*nr;

vbig = full(sparse(y(:),x(:),v(idx)));
