function A = apply_image(I,bars,wc)  
%
%  aout = apply_image(gx,gy,wc)
%
%

[nr,nc] =size(I);

w = 2*wc+1;

lws = 4;

gap = 10;

s1 = floor((nr-w)/gap);
s2 = floor((nc-w)/gap);

A = zeros(s1*s2,s1*s2);

sigma.text = 0.20;
sigma.mag = 0.20;
sigma.inten = 0.15;

for j=1:s1,
	for k=1:s2,

	    
	    c1 = [(wc+1)+(k-1)*gap,(wc+1)+(j-1)*gap];
            fprintf('.');
            for jj=j-lws:j+lws,
		for kk=k-lws:k+lws,

			c2 = [(wc+1)+(kk-1)*gap,(wc+1)+(jj-1)*gap];
			if ( (jj>0) & (kk>0) & (jj <= s1) & (kk <= s2)),
				
				J1 = get_win(I,c1,[wc,wc]);
 				J2 = get_win(I,c2,[wc,wc]);

				Jbars1 = get_win5(bars,c1,[wc,wc]);
				Jbars2 = get_win5(bars,c2,[wc,wc]);
				

				hists1 = get_hist(J1,Jbars1);
				hists2 = get_hist(J2,Jbars2);
				
				cumhists1 = get_cumhist(hists1);
				cumhists2 = get_cumhist(hists2);

				
				diff.inten = max(abs(cumhists1.inten-cumhists2.inten));
				diff.mag   = max(abs(cumhists1.mag-cumhists2.mag));
				diff.text  = max(max(abs(cumhists1.text-cumhists2.text)));

				diffs = max([diff.inten/sigma.inten,...
                                             diff.mag/sigma.mag,...
                                             diff.text/sigma.text]);

				dx = abs(k-kk);dy = abs(j-jj);
				sp_diff = sqrt(dx.^2+dy.^2)/4;
				
				A(j+(k-1)*s1,jj+(kk-1)*s1) = exp(-diffs-sp_diff);
			
			end
			
		end
	     end
      end
end


