function RGB = showmask(V,M,M2,display_flag);
% showmask(V,M);
%
% M is a nonneg. mask

V=V-min(V(:));
V=V/max(V(:));
V=.25+0.75*V; %brighten things up a bit

M=M-min(M(:));
M=M/max(M(:));

H=0.6*M2+0*M;
S=min(1,M2+M);
RGB=hsv2rgb(H,S,V);

%if nargin>2
   image(RGB)
   axis('image')
%end
