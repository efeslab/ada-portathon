function v = backproj_outer_chank(fvs,u,d,chank_size)
%
%  given the eigenvecs of the hist.bin. features
%  computes the back projection on the eigenvects
%

[nv,np] = size(fvs);
[nbins,nv] = size(u);

n_chanks = ceil(np/chank_size);

v = ones(np,nv);

for j=1:n_chanks,
  fprintf('<');
  
  cm = sprintf('load st_%d',j);
  eval(cm);
  fprintf(sprintf('%d',n_chanks-j));	

  ms = mean(fh');
  fh = fh - ms'*ones(1,size(fh,2));

  v((j-1)*chank_size+1:min(np,j*chank_size),:) = fh'*u;
  fprintf('>');
end

fprintf('\n');

s = 1./sqrt(d);

for j=1:nv,
  v(:,j) = v(:,j)*s(j);
end


