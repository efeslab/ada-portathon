function A = apply_image(gx,gy,I,wc)  
%
%  aout = apply_image(gx,gy,wc)
%
%

[nr,nc] =size(gx);

w = 2*wc+1;

lws = 4;

s1 = floor(nr/w);
s2 = floor(nc/w);

A = zeros(s1*s2,s1*s2);

for j=1:s1,
	for k=1:s2,
	    c1 = [(wc+1)+(k-1)*w,(wc+1)+(j-1)*w];
            fprintf('.');

            for jj=j-lws:j+lws,
		for kk=k-lws:k+lws,

			c2 = [(wc+1)+(kk-1)*w,(wc+1)+(jj-1)*w];
			if ( (jj>0) & (kk>0) & (jj <= s1) & (kk <= s2)) 
			a = compute_diff_patch(get_win(gx,c1,[wc,wc]),...
                       		get_win(gy,c1,[wc,wc]),...
		       		get_win(gx,c2,[wc,wc]),...
                       		get_win(gy,c2,[wc,wc]),...
		       		get_win(I,c1,[wc,wc]),...
                      		get_win(I,c2,[wc,wc]));

				dx = abs(k-kk);dy = abs(j-jj);
				sp_diff = exp(-sqrt(dx.^2+dy.^2)/4);
				A(j+(k-1)*s1,jj+(kk-1)*s1) = a*sp_diff;
			
			end
			
		end
	     end
      end
end


