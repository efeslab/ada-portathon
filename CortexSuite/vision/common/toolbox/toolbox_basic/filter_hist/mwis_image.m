function [l1,l2,phi] = mwis_image(gx,gy,hs)
%
%  [l1,l2,phi] = mwis_image(gx,gy)
%
%

if (~exist('hs')),
  hs = 10;
end


sgx = gx.*gx;
sgxy = gx.*gy;
sgy = gy.*gy;

ssgx = smooth(sgx,hs);
ssgxy = smooth(sgxy,hs);
ssgy = smooth(sgy,hs);

tr = ssgx + ssgy;
v1 = 0.5*sqrt(tr.*tr - 4*(ssgx.*ssgy-ssgxy.*ssgxy));
l1 = real(0.5*tr+v1);
l2 = real(0.5*tr-v1);

phi= 0.5*atan2(2*sgxy,sgx-sgy);
