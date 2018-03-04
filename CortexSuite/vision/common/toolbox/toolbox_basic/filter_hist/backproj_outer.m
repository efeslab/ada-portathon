function v = backproj_outer(fvs,u,hb)
%
%  given the eigenvecs of the hist.bin. features
%  computes the back projection on the eigenvects
%

[nv,np] = size(fvs);

for j=1: