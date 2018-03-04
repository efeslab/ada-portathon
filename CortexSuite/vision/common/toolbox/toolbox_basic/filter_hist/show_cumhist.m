function show_hist(cumhists,bins,fig_id,hold_flag,ct)
%%
%    show_hist(cumhists,bins,fig_id,ct)
%
%

	if (~exist('ct')),
		ct = 'b-o';
	end

	figure(fig_id);

	subplot(3,3,1);plot(bins.inten,cumhists.inten,ct);

	if (hold_flag == 1), hold on;else hold off; end

	for j=1:size(cumhists.text,2),
  	   subplot(3,3,1+j);
           plot(bins.text,cumhists.text(:,j),ct);
           if (hold_flag == 1), hold on;else hold off; end
	end

        subplot(3,3,8);
	plot(bins.mag,cumhists.mag,ct);
	if (hold_flag == 1), hold on;else hold off; end

	
	
