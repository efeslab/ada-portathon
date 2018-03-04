function [H,h] = make_filter(txture,sze,n_c,a,b,c)
%  function H = make_filter(txture,sze)
%
%

x = zeros(sze);
tx_sze = size(txture);

x(1:tx_sze(1),1:tx_sze(2)) = txture;
%figure(1);imagesc(x);drawnow;
x = reshape(x,1,sze(1)*sze(2));
X = fft(x);
power = abs(X).^2;

figure(3);plot(power);
len = length(X);

t = [1:0.5*(length(X)-1),0.5*(length(X)-1):-1:1];

top = max(power);
if (c == -1),
  c = top*5.0e-1
end
if (n_c == -1),
  n_c = top*1.0e-1
end

nois = n_c +c*(exp(-a*(t.^b)));
if (rem(len,2) == 1), 
 noise = [c+n_c,nois];
else 
 noise = [c+n_c,nois,c+n_c];
end

figure(3);hold on;plot(noise,'r');
hold off
H = X./(abs(X).^2+noise);
h = reshape(real(ifft(H)),sze(1),sze(2));
figure(2);imagesc(h);

figure(4);plot(abs(H).^2,'c')
%figure(3); mesh(h);

