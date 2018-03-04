function G=dog1(sig,N);
% G=dog1(sig,N);

% by Serge Belongie

no_pts=N;  % no. of points in x,y grid

[x,y]=meshgrid(-(N/2)+1/2:(N/2)-1/2,-(N/2)+1/2:(N/2)-1/2);

sigi=0.71*sig;
sigo=1.14*sig;
Ci=diag([sigi,sigi]);
Co=diag([sigo,sigo]);

X=[x(:) y(:)];

Ga=gaussian(X,[0 0]',Ci);
Ga=reshape(Ga,N,N);
Gb=gaussian(X,[0 0]',Co);
Gb=reshape(Gb,N,N);

a=1;
b=-1;

G = a*Ga + b*Gb;

G=G-mean(G(:));

