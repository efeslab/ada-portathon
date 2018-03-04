function [G]=doog2(sig,r,th,N);
% [G,H]=doog2(sig,r,th,N);
% Make difference of offset gaussians kernel
% theta is in degrees
% (see Malik & Perona, J. Opt. Soc. Amer., 1990)
%
% Example:
% >> imagesc(-doog2(.5,4,15,32))
% >> colormap(gray)

% by Serge Belongie

no_pts=N;              % no. of points in x,y grid
pad_pts=no_pts*sqrt(2); % pad grid dimensions for up to a 45 degree rotation
siz=6;                  % range of x,y grid 

[x,y]=meshgrid(linspace(-siz,siz,pad_pts),linspace(-siz,siz,pad_pts));

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
%Ho = imag(hilbert(Go));
G = Go;

G = mimrotate(Go,th,'bilinear','crop');
G = imcrop(G,[(pad_pts-no_pts)/2, (pad_pts-no_pts)/2, no_pts, no_pts]);

%H = imrotate(Ho,th,'bilinear','crop');
%H = imcrop(H,[(pad_pts-no_pts)/2, (pad_pts-no_pts)/2, no_pts, no_pts]);


