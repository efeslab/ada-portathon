function dog2 = mkdog2(sigma_base,size_w)
%
% function dog2 = mkdog2(sigma_base,size_w)
%
%

%scale_base = 1.224; 
scale_base = 4.15;

a = scale_base;
b = -2*scale_base;
c = scale_base;

sigma_a = 0.62*sigma_base;
sigma_b = sigma_base;
sigma_c = 1.6*sigma_base;

dog2 = a*mkg(0,0,sigma_a,sigma_a,size_w) +...
       b*mkg(0,0,sigma_b,sigma_b,size_w) +...
       c*mkg(0,0,sigma_c,sigma_c,size_w);

%dog2 = 255*5.1745*dog2;