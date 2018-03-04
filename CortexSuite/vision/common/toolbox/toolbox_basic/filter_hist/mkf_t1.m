function [H,h] = make_filter(txture,sze,noise)
%  function H = make_filter(txture,sze)
%
%

tx_sze = size(txture);
x = reshape(txture,1,tx_sze(1)*tx_sze(2));
X = fft(x);
H = X./(abs(X).^2+noise);
h = reshape(real(ifft(H)),tx_sze(1),tx_sze(2));


x = zeros(sze);
x(1:tx_sze(1),1:tx_sze(2)) = h;
figure(1);imagesc(x);drawnow;
x = reshape(x,1,sze(1)*sze(2));
H = fft(x);

h = reshape(real(ifft(H)),sze(1),sze(2));
figure(2);imagesc(h);

figure(3); mesh(h);