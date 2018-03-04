function fh = colize_hist(fv,hb)
%      (hb = sigs,bin_mins,bin_maxs,nbins)
%
%   fv = [nfeature x npoints];
%   fh = [nfeatures*nbins x npoints];
%
%  take a feature matrix, and turn it into histogram bin feature matrix
%
%

[nf,np] = size(fv);

nbins = [0,hb.nbins];
disp(sprintf('need matrix of %d x %d ',sum(nbins),np));

fh = zeros(sum(nbins),np);

for k=1:nf,
  bin_min = hb.bmins(k);
  bin_max = hb.bmaxs(k);
  nbin    = nbins(k+1);
  sig     = hb.sigs(k);
  fprintf('.');
     b = binize(fv(k,:),sig,bin_min,bin_max,nbin);
     fh(sum(nbins(1:k))+1:sum(nbins(1:k+1)),:) = b;
  
end

fprintf('\n');
