function [l1,l2,phi] = mwis(gx,gy)
%
%  [l1,l2,phi] = mwis(gx,gy)
%
%

sgx = sum(sum(gx.*gx));
sgxy = sum(sum(gx.*gy));
sgy = sum(sum(gy.*gy));

tr = sgx + sgy;
v1 = 0.5*sqrt(tr*tr - 4*(sgx*sgy-sgxy*sgxy));
l1 = real(0.5*tr+v1);
l2 = real(0.5*tr-v1);

phi= 0.5*atan2(2*sgxy,sgx-sgy);
