function [A,D] = find_AD(I,J,mask,w)
%
%  [A,D] = find_AD(I,J,mask,w)
%
%    find the matrix affine transform A and displacement D,
%    such that SSD difference of  I(Ax-d)-J(x) is minimized,
%   

%
% Jianbo Shi
%


[gy1,gx1] = grad(I,w);
[gy2,gx2] = grad(J,w);

gx = 0.5*(gx1+gx2);
gy = 0.5*(gy1+gy2);

[size_y,size_x] = size(I);
[center_y,center_x] = find_center(size_y,size_x);
mask = mask(w+1:size_y-w,w+1:size_x-w);

[x,y] = meshgrid(1:size_x,1:size_y);
x = x- center_x;
y = y-center_y;

x = x(w+1:size_y-w,w+1:size_x-w);
y = y(w+1:size_y-w,w+1:size_x-w);

gx_sqr = gx.*mask.*gx;
gx_gy = gx.*mask.*gy;
gy_sqr = gy.*mask.*gy;

x_sqr = x.*x;
x_y = x.*y;
y_sqr = y.*y;

T= zeros(6,6);
T(1,1) = 0.5*trapz(trapz(gx_sqr.*x_sqr));
T(2,1) = trapz(trapz(gx_gy.*x_y));
T(3,1) = trapz(trapz(gx_sqr.*x_y));
T(4,1) = trapz(trapz(gx_gy.*x_sqr));
T(5,1) = trapz(trapz(gx_sqr.*x));
T(6,1) = trapz(trapz(gx_gy.*x));
T(2,2) = 0.5*trapz(trapz(gy_sqr.*y_sqr));
T(3,2) = trapz(trapz(gx_gy.*y_sqr));
T(4,2) = trapz(trapz(gy_sqr.*x_y));
T(5,2) = trapz(trapz(gx_gy.*y));
T(6,2) = trapz(trapz(gy_sqr.*y));
T(3,3) = 0.5*trapz(trapz(gx_sqr.*y_sqr));
T(4,3) = trapz(trapz(gx_gy.*x_y));
T(5,3) = trapz(trapz(gx_sqr.*y));
T(6,3) = trapz(trapz(gx_gy.*y));
T(4,4) = 0.5*trapz(trapz(gy_sqr.*x_sqr));
T(5,4) = trapz(trapz(gx_gy.*x));
T(6,4) = trapz(trapz(gy_sqr.*x));
T(5,5) = 0.5*trapz(trapz(gx_sqr));
T(6,5) = trapz(trapz(gx_gy));
T(6,6) = 0.5*trapz(trapz(gy_sqr));

T = T+T';

J = J(w+1:size_y-w,w+1:size_x-w);
I = I(w+1:size_y-w,w+1:size_x-w);


diff = (J-I).*mask;
b(1) = trapz(trapz(diff.*gx.*x));
b(2) = trapz(trapz(diff.*gy.*y));
b(3) = trapz(trapz(diff.*gx.*y));
b(4) = trapz(trapz(diff.*gy.*x));
b(5) = trapz(trapz(diff.*gx));
b(6) = trapz(trapz(diff.*gy));

a = inv(T)*b';

A = [1+a(1), a(3);
a(4),1+a(2)];

D= [a(5),a(6)];

