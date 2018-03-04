function [H,h] = make_filter(txture,sze,noise)
%  function H = make_filter(txture,sze)
%
%

x = zeros(sze);
tx_sze = size(txture);

[center_x,center_y] = find_center(sze(2),sze(1));
tx_sze_h = round(0.5*tx_sze);

x(center_y-tx_sze_h(1):center_y-tx_sze_h(1)+tx_sze(1)-1,...
  center_x-tx_sze_h(2):center_x-tx_sze_h(2)+tx_sze(2)-1) = txture;
figure(1);imagesc(x);drawnow;
x = reshape(x,1,sze(1)*sze(2));
X = fft(x);
H = X./(abs(X).^2+noise);
h = reshape(real(ifft(H)),sze(1),sze(2));
figure(2);imagesc(h);

figure(3); mesh(h);