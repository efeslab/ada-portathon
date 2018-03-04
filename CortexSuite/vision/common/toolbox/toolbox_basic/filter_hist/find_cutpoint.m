function [cutpoints,x] = find_cutpoint(data,cmap,nbin)
%
%  [cutpoints,x] = find_cutpoint(data,cmap,nbin)
%
%

x = id_cut(data,cmap,nbin);

cutpoints = zeros(1,nbin);

for j=1:nbin,
 cutpoints(j) = max(data(x<=j));
end
