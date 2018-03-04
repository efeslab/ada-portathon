function J = expand(I)
%
%

[sy,sx] = size(I);
[x,y] = meshgrid(1:2*sx+1,1:2*sy+1);

nx = 