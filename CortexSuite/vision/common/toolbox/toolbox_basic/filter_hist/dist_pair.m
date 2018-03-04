function d = dist_pair(idx,fv,hb)
%     (hb=sigs,bin_mins,bin_maxs,nbins)
%
%
%  computes the pairwise distance between
%  a point and everyone else using histogram binized feature
% 


[nf,np] = size(fv);

d = zeros(1,np);
nbins = [0,hb.nbins];


for j=1:nf,
	bin_min = hb.bmins(j);
  	bin_max = hb.bmaxs(j);
  	nbin    = nbins(j+1);
  	sig     = hb.sigs(j);
  	fprintf(sprintf('|%d',j));
    	b = binize(fv(j,:),sig,bin_min,bin_max,nbin);

	a = binize(fv(j,idx),sig,bin_min,bin_max,nbin);

	d = d + a'*b;
end
fprintf('\n');
