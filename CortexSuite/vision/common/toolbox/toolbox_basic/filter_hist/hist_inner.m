function fh = hist_inner(fv,hb)
%         (hb = bin_mins,bin_maxs,nbins)
%
%  take which histogram value and turn it into histogram bin
%  compute the inner product of the histogram bin features
%

[nf,np] = size(fv);

nbins = [0,hb.nbins];

disp(sprintf('need matrix of %d x %d ',sum(nbins),sum(nbins)));

fh = zeros(sum(nbins),sum(nbins));

for j=1:nf,
  bin_min = hb.bmins(j);
  bin_max = hb.bmaxs(j);
  nbin    = nbins(j+1);
  sig     = hb.sigs(j);
  fprintf('|');
  b0 = binize(fv(j,:),sig,bin_min,bin_max,nbin);

  fh(sum(nbins(1:j))+1:sum(nbins(1:j+1)),sum(nbins(1:j))+1:sum(nbins(1:j+1))) = b0*b0';
  
  for k=j+1:nf,
  	bin_min = hb.bmins(k);
  	bin_max = hb.bmaxs(k);
  	nbin    = nbins(k+1);
  	sig     = hb.sigs(k);
  	fprintf('.');
     	b = binize(fv(k,:),sig,bin_min,bin_max,nbin);
        tmp = b0*b';

	fh(sum(nbins(1:j))+1:sum(nbins(1:j+1)),sum(nbins(1:k))+1:sum(nbins(1:k+1))) = tmp;
        fh(sum(nbins(1:k))+1:sum(nbins(1:k+1)),sum(nbins(1:j))+1:sum(nbins(1:j+1))) = tmp';
  end
end

fprintf('\n');
