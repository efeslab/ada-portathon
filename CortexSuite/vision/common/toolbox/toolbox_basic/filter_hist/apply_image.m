function [aout1,aout2,aout3,aout4] = apply_image(gx,gy,wc)  
%
%  aout = apply_image(gx,gy,wc)
%
%

[nr,nc] =size(gx);

w = 2*wc+1;

aout1 = ones(nr,nc);
aout2 = zeros(nr,nc);
aout3 = aout2;
aout4 = aout2;

%mask = smooth(ones(w,w),w);
%sig = w;
%[x,y] = meshgrid(-wc:wc,-wc:wc);
%mask = exp(-(x.*x)/sig).*exp(-(y.*y)/sig);
%mask = mask/sum(sum(mask));


tmp = ones(w,w);
for j=wc+1:w:nr-wc-1,
	for k=wc+1:w:nc-wc-1,
                tgx = get_win(gx,[k,j],[wc,wc]);
		tgy = get_win(gy,[k,j],[wc,wc]);
		%mag = sum(sum(sqrt((mask.*tgx).^2+(mask.*tgy).^2)));
		mag = sum(sum(sqrt(tgx.^2 + tgy.^2)))/prod(size(tgy));
		
		M = is_step(tgx,tgy);

		aout1(j-wc:j+wc,k-wc:k+wc) = M(1)*tmp;
		aout2(j-wc:j+wc,k-wc:k+wc) = M(2)*tmp;
		aout3(j-wc:j+wc,k-wc:k+wc) = M(3)*tmp;
		aout4(j-wc:j+wc,k-wc:k+wc) = mag*tmp;
	end
end
