function fh = colize_joint_hist(fv,hb)
%      (hb = sigs,bin_mins,bin_maxs,nbins)
%
%  take which histogram value and turn it into histogram bin
%


	[nf,np] = size(fv);

	nbins = [0,hb.nbins];
	%disp(sprintf('need matrix of %d x %d ',prod(hb.nbins),np));

	fh = zeros(hb.nbins(1),hb.nbins(2),np);

	k=1;
  		bin_min = hb.bmins(k);
  		bin_max = hb.bmaxs(k);
		nbin    = nbins(k+1);
		sig     = hb.sigs(k);
		%fprintf('.');

		b1 = binize(fv(k,:),sig,bin_min,bin_max,nbin);
	k=2;
		bin_min = hb.bmins(k);
  		bin_max = hb.bmaxs(k);
		nbin    = nbins(k+1);
		sig     = hb.sigs(k);
		%fprintf('.');

		b2 = binize(fv(k,:),sig,bin_min,bin_max,nbin);

	
	for k=1:hb.nbins(1),
	   for j=1:hb.nbins(2),
		fh(k,j,:) = b1(k,:).*b2(j,:);
  	   end
	end

%fprintf('\n');

fh = reshape(fh,hb.nbins(1)*hb.nbins(2),np);
