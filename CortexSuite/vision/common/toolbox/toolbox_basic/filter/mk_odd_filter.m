function G=doog2(sig,r,th,N);
% [G,H]=doog2(sig,r,th,N);
% Make difference of offset gaussians kernel
% theta is in degrees
% (see Malik & Perona, J. Opt. Soc. Amer., 1990)
%


[x,y]=meshgrid(-N:N,-N:N);

a=-1;
b=2;
c=-1;

ya=sig;
yc=-ya;
yb=0;
sigy=sig;
sigx=r*sig;

Ga=(1/(2*pi*sigx*sigy))*exp(-(((x-0)/sigx).^2+((y-ya)/sigy).^2));
Gb=(1/(2*pi*sigx*sigy))*exp(-(((x-0)/sigx).^2+((y-yb)/sigy).^2));
Gc=(1/(2*pi*sigx*sigy))*exp(-(((x-0)/sigx).^2+((y-yc)/sigy).^2));

Go = a*Ga + b*Gb + c*Gc;
Ho = imag(hilbert(Go));
%G = Ho;

G = mimrotate(Ho,th,'bilinear','crop');

G = G-mean(reshape(G,prod(size(G)),1));

G = G/sum(sum(abs(G)));



