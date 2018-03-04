% function RGB=showmask(V,M,hue);
% Input:
%    V = image
%    M = nonnegative mask
%    hue = a number in [0,1], red,yellow,green,cyan,...,red
%          a char, 'r','g','b','y','c','m'
%          or a matrix of the same size of image
%          eg. hue = mask1 * 0.7 + mask2 * 1;
%   
% Output:
%    RGB = an RGB image with V as shades and M as saturated hues
%    If no output is required, this image is displayed.

% Stella X. YU, 2000.  Based on Jianbo Shi's version.

function RGB=showmask(V,M,hue);

if nargin<3 | isempty(hue),
   hue = 0;
end
if ischar(hue),
    switch hue,
        case 'r', hue = 1.0;
        case 'g', hue = 0.3;
        case 'b', hue = 0.7;
        case 'y', hue = 0.15;
        case 'c', hue = 0.55;
        case 'm', hue = 0.85;
    end
end
        

V=V-min(V(:));
V=V/max(V(:));
V=.25+0.75*V; %brighten things up a bit

M = double(M);
M = M-min(M(:));
M = M/max(M(:));

H = hue+zeros(size(V));
S = M;
RGB = hsv2rgb(H,S,V);

if nargout>0,   
   return;
end

hold off; image(RGB); axis('image');
s = cell(1,2);
if isempty(inputname(1)),
   s{1} = 'image';
else
   s{1} = inputname(1);
end
if isempty(inputname(2)),
   s{2} = 'mask';
else
   s{2} = inputname(2);
end
title(sprintf('%s and colored %s',s{1},s{2}));

if nargout==0,
    clear RGB; 
end
