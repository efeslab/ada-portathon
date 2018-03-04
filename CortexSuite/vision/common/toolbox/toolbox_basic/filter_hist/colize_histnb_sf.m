function fhs = colize_histnb_s(fvs,Is,hb,nw,hw)
%
%  fhs = colize_histneigh(fvs,Is,hb,nw,hw)
%         
%

[nf,np] = size(fvs);

[nr,nc] = size(Is);

st_sz = 2*hw + 1;

nr_chank = floor(nr/st_sz);
nc_chank = floor(nc/st_sz);

tnbins = prod(hb.nbins(1:nf));
disp(sprintf('allocat memory for %d x %d',tnbins,nr_chank*nc_chank));

fhs = zeros(tnbins,nr_chank*nc_chank);

idx = 0;
for k=1+hw:st_sz:nc-hw,
	
	fprintf(',');
	sk = max(1,k-nw);
        ek = min(nc,k+nw);

	
	% for each column,
	for j=1+hw:st_sz:nr-hw,
    	   sj = max(1,j-nw);
	   ej = min(nr,j+nw);
	
	   id = j+(k-1)*nr;
	   idx = idx+1;

	   %% find idx for the neighboring points
	   lis = [sj:ej]'*ones(1,ek-sk+1);
           ljs = ones(ej-sj+1,1)*[sk:ek];
           idns = lis+(ljs-1)*nr;
	   
	   fh = colize_joint_hist(fvs(:,idns(:)),hb);

	   fhs(:,idx) = sum(fh')';

	end
end

fprintf('\n');

           
   