% function a = afromncut(v,s,d,visimg,no_rep,pixel_loc)
% Input:
%    v = eigenvectors of d*a*d, starting from the second.
%      (the first is all one over some constant determined by d)
%    s = eigenvalues
%    d = normalization matrix 1/sqrt(rowsum(abs(a)))
%    visimg = 1/0 if each eigenvector is/not 2D (so v is 3D)
%    no_rep = 1 (default), affinity has attraction only
%        if 1, the first column of v is the second eigenvector
%        if 0, the first column of v is the first eigenvector.
%    pixel_loc = nx1 matrix, each is a pixel location
% Output:
%    a = diag(1/d) * na * diag(1/d);
%    If pixel_loc = []; a is returned, if not out of memory
%    otherwise, only rows of a at pixel_loc are returned.
%
% This routine is used to estimate the original affinity matrix
% through the first few eigenvectors and its normalization matrix.

% A test sequence includes:
% a = randsym(5);
% [na,d] = normalize(a);
% [v,s] = ncut(a,5);
% v = v(:,2:end); s = s(2:end);
% aa = afromncut(v,s,d);
% max(abs(aa(:) - a(:)))

% Stella X. Yu, 2000.

function a = afromncut(v,s,d,visimg,no_rep,pixel_loc)

[nr,nc,nv] = size(v);
if nargin<4 | isempty(visimg),
   visimg = (nv>1);
end

if nargin<5 | isempty(no_rep),
   no_rep = 1;
end

if visimg,
   nr = nr * nc;
else
   nv = nc;
end

if nargin<6 | isempty(pixel_loc),
   pixel_loc = 1:nr;
end

% D^(1/2)
d = 1./(d(:)+eps);

% first recover the first eigenvector
if no_rep,
    u = (1/norm(d)) + zeros(nr,1);
    s = [1;s(:)];
    nv = nv + 1;
else
    u = [];
end

% the full set of generalized eigenvectors
v = [u, reshape(v,[nr,nv-no_rep])];

% This is the real D, row sum
d = d.^2;

% an equivalent way to compute v = diag(d) * v;
v = v .* d(:,ones(nv,1)); % to avoid using a big matrix diag(d)

% synthesis
a = v(pixel_loc,:)*diag(s)*v';
