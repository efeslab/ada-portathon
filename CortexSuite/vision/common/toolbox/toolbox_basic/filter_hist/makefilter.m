function H = make_filter(txture,sze,noise)
%  function H = make_filter(txture,sze)
%
%

x = zeros(sze);
tx_sze = size(txture);

x(1:tx_sze(1),1:tx_sze(2)) = txture;
x = reshape(x,1,sze(1)*sze(2));
X = fft(x);
figure(3);plot(abs(X).^2);

H = X./(abs(X).^2+noise);
