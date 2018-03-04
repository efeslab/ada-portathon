function output = Bfilters(img,H,w)
%
%  function output = Bfilter(img,H,w)
%

sze = size(img);
w_h = round(0.5*(w-1));

Y = fft(reshape(img,1,sze(1)*sze(2)));
C = Y.*conj(H);
c = real(ifft(C));
o = reshape(c,sze(1),sze(2));

output(1:w_h(1),1:w_h(2)) = o(sze(1)-w_h(1)+1:sze(1),sze(2)-w_h(2)+1:sze(2));
output(1:w_h(1),w_h(2)+1:sze(2)) = o(sze(1)-w_h(1)+1:sze(1),1:sze(2)-w_h(2));
output(w_h(1)+1:sze(1),w_h(2)+1:sze(2)) = o(1:sze(1)-w_h(1),1:sze(2)-w_h(2));
output(w_h(1)+1:sze(1),1:w_h(2)) = o(1:sze(1)-w_h(1),sze(2)-w_h(2)+1:sze(2));
