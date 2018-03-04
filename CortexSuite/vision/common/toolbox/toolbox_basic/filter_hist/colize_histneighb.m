function fhs = colize_histneigh(fh,Is,nw)
%
%  fhs = colize_histneigh(fh,fvs,nw)
%         
%

[tnbins,np] = size(fh);

[nr,nc] = size(Is);

fhs = zeros(size(fh));

for j=1:nr,
	fprintf('.');
	sj = max(1,j-nw);
	ej = min(nr,j+nw);
	
	% for each column,
	for k=1:nc,
    	   sk = max(1,k-nw);
           ek = min(nc,k+nw);

	   id = j+(k-1)*nr;

	   for li=sj:ej,
	      for lj=sk:ek,
                idn = li+(lj-1)*nr;

		fhs(:,id) = fhs(:,id) + fh(:,idn);
	      end
	   end
	end
end
fprintf('\n');

           
   