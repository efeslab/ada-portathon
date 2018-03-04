function doog2 = mkdoog2(sigma_w,r,theta,size_w)
%
% function doog2 = mkdoog2(sigma_w,r,theta,size_w)
%
%

%scale_base = 2.8814; 
scale_base = 2;

a = -1*scale_base;
b = 2*scale_base;
c = -1*scale_base;

sigma_x = r*sigma_w;
sigma_y = sigma_w;

ya = sigma_w;
yc = -sigma_w;
yb = 0;

doog2 = a*mkg(0,ya,sigma_x,sigma_y,size_w) +...
        b*mkg(0,yb,sigma_x,sigma_y,size_w) +...
        c*mkg(0,yc,sigma_x,sigma_y,size_w);

%doog2 = 255*5.1745*doog2;





