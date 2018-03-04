function covfh = hist_inner_chank(fv,chank_size,nbin)
%  fh = hist_inner_chank(fv,hb,chank_file)
%
%         (hb = bin_mins,bin_maxs,nbins)
%
%  take which histogram value and turn it into histogram bin
%  compute the inner product of the histogram bin features
%

[nf,np] = size(fv);

tbins = nf*nbin;
disp(sprintf('need matrix of %d x %d ',tbins,tbins));

covfh = zeros(tbins,tbins);

n_chanks = ceil(np/chank_size);
for j=1:n_chanks,
  fprintf('<');
  
  cm = sprintf('load st_%d',j);
  eval(cm);
  fprintf(sprintf('%d',n_chanks-j));

  %ms = mean(fh');
  %fh = fh- ms'*ones(1,size(fh,2));

  covfh = covfh + fh*fh';
  fprintf('>');
end

fprintf('\n');

