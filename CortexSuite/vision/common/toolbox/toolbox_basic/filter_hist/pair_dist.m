function A = apply_image(gx,gy,I,wc)  
%
%  aout = apply_image(gx,gy,wc)
%
%

[nr,nc] =size(gx);

w = 2*wc+1;

s1 = floor(nr/w);
s2 = floor(nc/w);

A = zeros(s1*s2,s1*s2);

yid = 0;
for j=wc+1:w:nr-wc-1,
	yid = yid+1;
	xid = 0;
	for k=wc+1:w:nc-wc-1,
		xid = xid + 1;
		c1 = [k,j];

		yyid = 0;
		fprintf('.');
		for jj=wc+1:w:nr-wc-1,
			yyid = yyid+1;
			xxid = 0;
			for kk=wc+1:w:nc-wc-1,
				xxid = xxid + 1;

				c2 = [kk,jj];

				a = compute_diff_patch(get_win(gx,c1,[wc,wc]),...
                       		get_win(gy,c1,[wc,wc]),...
		       		get_win(gx,c2,[wc,wc]),...
                       		get_win(gy,c2,[wc,wc]),...
		       		get_win(I,c1,[wc,wc]),...
                      		get_win(I,c2,[wc,wc]));

				A(yid+(xid-1)*s1,yyid+(xxid-1)*s1) = a;
			end
		end
	end
end
