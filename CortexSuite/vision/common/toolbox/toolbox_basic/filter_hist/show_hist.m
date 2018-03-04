function show_hist(hists,bins,fig_id)
%%
%    show_hist(hists,bins,fig_id)
%
%

	figure(fig_id);

	subplot(3,3,1);bar(bins.inten,hists.inten);

	%maxval = max(max(max(abs(Jbar))));

	for j=1:size(hists.text,2),
  	   subplot(3,3,1+j);% hist(reshape(abs(Jbar(:,:,j)),prod(w),1),[1:10:maxval+1]);
           bar(bins.text,hists.text(:,j));
	end

        subplot(3,3,8);%hist(reshape(sum(abs(Jbar),3),prod(w),1),[1:10:161]);
	bar(bins.mag,hists.mag);


	
	
