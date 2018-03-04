% function [v,s,na,d] = ncutd(a,nv,beta,sigma,offset) 
% Input:
%    a = (attraction + i*repulsion), both nonnegative but could be asymmetrical
%    nv = number of eigenvectors v
%    beta = weighting between undirected graph and directed graph
%        beta = 1, undirected; beta = 0, directed.  Default = 0.5
%    sigma = refer to EIGS.M, 0 for smallest, default = 'LR'
%    offset = vector, each for an affinity matrix, 
%       per_edge offset for nondirectional attraction and repulsion
% Output:
%    v = generalized eigenvectors of A and D
%    s = eigenvalues
%    na = normalized affinity matrix
%    d = normalization matrix 1/sqrt(rowsum(a))
% This version now accepts multiple weight matrices
% the format of cells are good for sparse affinity matrices

% Stella X. Yu, 2001.

function [v,s,na,d] = ncutd(a,nv,beta,sigma,offset)

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

if nargin<3 | isempty(beta),
   beta = 0.5;
end
beta = beta *2;

if nargin<4 | isempty(sigma),
   sigma = 'LR';
end

if nargin<5 | isempty(offset),
   offset = 0;
end;
offset=offset(:);
j = length(offset);
offset(j+1:nw) = offset(j);

% modify per-edge offset delta to 2 D_{\delta} = offset to D_R
offset = offset * (2*nc);

z = zeros(nr,nw);
na = 0;
for j=1:nw, % simultaneous partitioning with multiple weight matrices.
   if is_cell,
      w = a{j};
   elseif issparse(a), % only supports 2D indexing
      w = a;
   else
      w = a(:,:,j);
   end
   
   wr = real(w); % attraction
   wi = imag(w); % repulsion
   
   % if wr has negative numbers, treat as repulsion
   % while negative numbers in wi is ignored
   aa = wr.*(wr>0);
   rr = wi.*(wi>0)-wr.*(wr<0);
   
   % decomposition
   au = aa + aa';
   ad = aa - aa';
   ru = rr + rr';
   rd = rr - rr';
   
   % construct equivalent matrices
   x = sum(ru,2);
   wr = au - ru + diag(x);
   wi = ad + rd;
   x = x + sum(au,2);
   
   % re-organize, add in offset and beta
   z(:,j) = x + 2 * offset;
   na = na + ( beta * (wr + offset) + sqrt(-1)* (2-beta) * wi  );
   
end
z = sum(z,2); % diag(z) = single equivalent D

% normalize
d = repmat(1./sqrt(z+eps),1,nc);
na = d.*na;
na = na.*d';

options.disp = 0; 
%options.tol = 1e-10;
%options.maxit = 15;

[v,s] = eigs(na,nv,sigma,options);
s = real(diag(s));

% project back to get the eigenvectors for the pair (a,d)
% a x = lambda d x
% na y = lambda y
% x = d^(-1/2) y

v = v .* d(:,ones(nv,1));
