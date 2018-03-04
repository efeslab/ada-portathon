function [gx,gy] = grad2(I,ratio)
%
%

ddgauss = gradient(dgauss(ratio));ddgauss = ddgauss/sum(abs(ddgauss));
gkern = gauss(ratio); gkern = gkern/sum(abs(gkern));

gx = conv2(I,ddgauss,'same');
gx = conv2(gx,gkern','same');

gy = conv2(conv2(I,ddgauss','same'),gkern,'same');
