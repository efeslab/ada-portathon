% function [v,s,na,d] = ncut(a,nv,sigma,offset) 
% Input:
%    a = affinity matrix, hermitian, could be 3D, or a cell
%    nv = number of eigenvectors v
%    sigma = refer to EIGS.M, 0 for smallest, default = 'LR'
%    offset = vector, each for an affinity matrix, offset for nondirectional repulsion
%       W = A - R = (A + offset) - (R + offset)
%       Expected value = offset in affinity value * # of neighboors
% Output:
%    v = generalized eigenvectors of A and D
%    s = eigenvalues
%    na = normalized affinity matrix
%    d = normalization matrix 1/sqrt(rowsum(a))
% This version now accepts multiple weight matrices
% the format of cells are good for sparse affinity matrices

% Jianbo Shi

function [v,s,na,d] = ncut(a,nv,sigma,offset)

is_cell = iscell(a);
if is_cell,
   nw = length(a);
   [nr,nc] = size(a{1});
else
   [nr,nc,nw] = size(a);
end

if nargin<2 | isempty(nv),
   nv = min(nr,6);
end

if nargin<3 | isempty(sigma),
   sigma = 'LR';
end

if nargin<4 | isempty(offset),
   offset = 0;
end;
offset=offset(:);
j = length(offset);
offset(j+1:nw) = offset(j);

d = 0;
na = sparse(nr,nc);
for j=1:nw, % simultaneous partitioning with multiple weight matrices.
   if is_cell,
      w = a{j};
   elseif issparse(a), % only supports 2D indexing
      w = a;
   else
      w = a(:,:,j);
   end
   if j==nw, % to save space
       clear a;
   end
   
   d = d + sum(abs(w),2) + 2*offset(j); % single equivalent D
   
   % modify matrix a to deal with nondirectional repulsion 
   wr = real(w);
   wr = (sum(abs(wr),2)-sum(wr,2))*0.5 + offset(j);
   w = w + spdiags(wr,0,nr,nr);
   
   na = na + w; % single equivalent A
   
   % if you want the rectified individual weight matrix
   %if is_cell,
   %   a{j} = w;      
   %else
   %   a(:,:,j) = w;
   %end
end
clear w wr

% normalize
d = 1./sqrt(d+eps);
if 1,
    na = spmtimesd(na,d,d);    
else    
    d = spdiags(d,0,nr,nr);
    na = d * na * d;
end

options.disp = 0; 
%options.tol = 1e-10;
%options.maxit = 15;

warning off
[v,s] = eigs(na,nv,sigma,options);
s = real(diag(s));
warning on

% to make sure positive eigs always come first
% [x,y] = sort(-s); 
% s = -x;
% v = v(:,y);

% project back to get the eigenvectors for the pair (a,d)
% a x = lambda d x
% na y = lambda y
% x = d^(-1/2) y

if 1,
    v = spdiags(d,0,nr,nr) * v;
else
    v = d * v;
end    
