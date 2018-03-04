function dog1 = mkdog1(sigma_base,size_w)
%
% function dog1 = mkdog1(sigma_base,size_w)
%
%

%scale_base = 1; 
scale_base = 3;

a = scale_base;
c = -1*scale_base;

sigma_a = 0.71*sigma_base;
sigma_c = 1.14*sigma_base;

dog1 = a*mkg(0,0,sigma_a,sigma_a,size_w) +...
       c*mkg(0,0,sigma_c,sigma_c,size_w);

dog1 = dog1-mean(reshape(dog1,prod(size(dog1)),1));
dog1 = dog1/sum(sum(abs(dog1)));
