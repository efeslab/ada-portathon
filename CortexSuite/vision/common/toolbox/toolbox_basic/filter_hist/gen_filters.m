function filters = gen_filters(sig,r,sz);


as = 0:30:150;

filters = [];

if size(sig,2)== 1,

  for j = 1:length(as),
    fprintf('.');
    angle = as(j);

    g = mdoog2(sig,r,angle,round(sz));

    g = g - mean(reshape(g,prod(size(g)),1));

    g = g/sum(sum(abs(g)));

    filters(:,:,j) = g;
  end
else

  % there are multiple scales
  sigs = sig;
  szs = sz;
  for k = 1:size(sigs,2),
     sig = sigs(k);
     sz = szs(length(szs)-1);
     fprintf('%d',k);
     for j = 1:length(as),
    	fprintf('.');
    	angle = as(j);

    	g = mdoog2(sig,r,angle,round(sz));
	g = g - mean(reshape(g,prod(size(g)),1));
	g = g/sum(sum(abs(g)));

	filters(:,:,j,k) = g;
     end


  end

end

fprintf('\n');
