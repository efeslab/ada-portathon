function output = Bfilter(img,H)
%
%  function output = Bfilter(img,H)
%

sze = size(img);

Y = fft(reshape(img,1,sze(1)*sze(2)));
C = Y.*conj(H);
c = real(ifft(C));
output = reshape(c,sze(1),sze(2));
