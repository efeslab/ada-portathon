function d = dist_pair_chank(a,fvs,chank_size)
%     (hb=sigs,bin_mins,bin_maxs,nbins)
%
%
%  computes the pairwise distance between
%  a point and everyone else using histogram binized feature
% 


[nf,np] = size(fvs);

n_chanks = ceil(np/chank_size);

d = [];
for j=1:n_chanks,
	fprintf('<');

	cm = sprintf('load st_%d',j);
	eval(cm);
	fprintf(sprintf('%d',n_chanks-j));

	d = [d,a*fh];
end

fprintf('\n');
