function [gx,gy] = grad2(I,ratio)
%
%

kern = dgauss(ratio);kern = kern/sum(abs(kern));
gkern = gauss(ratio);gkern = gkern/sum(abs(kern));

gx = conv2(I,kern,'same');
gx = conv2(gx,gkern','same');

gy = conv2(conv2(I,kern','same'),gkern,'same');
