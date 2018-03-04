function D = find_D(I,J,mask,w)
%
%  function D = find_D(I,J,mask,w)
%
%  find the vector D such that it minimizes then
%  difference between I(Ax-d)-J(x).
%
%  mask: the weight matrix,
%  w: window size for estimating gradiant, use a large value
%     when A,D are large.
%

%
%  NOTE:  Because gradient values on the boarder regions of
%         I and J can not be computed accuately when using
%         a gaussian of large support, those boarder regions
%         of width w are not used in computing D.
%

%
%  Jianbo Shi
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


T= zeros(2,2);

T(1,1) = 0.5*trapz(trapz(gx_sqr));
T(2,1) = trapz(trapz(gx_gy));
T(2,2) = 0.5*trapz(trapz(gy_sqr));

T = T+T';

J = J(w+1:size_y-w,w+1:size_x-w);
I = I(w+1:size_y-w,w+1:size_x-w);


diff = (J-I).*mask;
b(1) = trapz(trapz(diff.*gx));
b(2) = trapz(trapz(diff.*gy));

a = inv(T)*b';

D= [a(1),a(2)];

