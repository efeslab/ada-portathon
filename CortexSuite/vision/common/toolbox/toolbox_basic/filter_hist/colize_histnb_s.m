function fhs = colize_histnb_s(fh,Is,nw,hw)
%
%  fhs = colize_histneigh(fh,fvs,nw)
%         
%

[tnbins,np] = size(fh);

[nr,nc] = size(Is);

st_sz = 2*hw + 1;

nr_chank = floor(nr/st_sz);
nc_chank = floor(nc/st_sz);

fhs = zeros(size(fh,1),nr_chank*nc_chank);

idx = 0;
for k=1+hw:st_sz:nc-hw,
	
	fprintf('.');
	sk = max(1,k-nw);
        ek = min(nc,k+nw);

	
	% for each column,
	for j=1+hw:st_sz:nr-hw,
    	   sj = max(1,j-nw);
	   ej = min(nr,j+nw);
	
	   id = j+(k-1)*nr;
	   idx = idx+1;
	   for li=sj:ej,
	      for lj=sk:ek,
                idn = li+(lj-1)*nr;

		fhs(:,idx) = fhs(:,idx) + fh(:,idn);
		
	      end
	   end
	end
end

fprintf('\n');

           
   