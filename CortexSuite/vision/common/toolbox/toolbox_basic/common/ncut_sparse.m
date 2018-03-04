function [v,d] = ncut(A,nv)
%
%  [v,d] = ncut(A,nv)
%
%    Assume A is sparse,
%
%    computes 'nv' of the normalized cut vectors 'v' from
%    matrix 'A'
%
%    it computes the largest eigenvectors of
%      A*v = \lambda D * v;   D = diag(sum(A));
%
%    this is same as solving the smallest eigenvectors of
%     (D-A)*v = \lambda D *v;
%   

%
%  Jianbo Shi   
%

ds = sum(abs(A));
ds = 1./sqrt(ds);

[id_i,id_j,W] = find(A);
A = sparse(id_i,id_j,ds(id_i)'.*ds(id_j)'.*(W));

%disp(sprintf('computing eig values'));
SIGMA = 'LM';
%OPTIONS.issym = 0;
OPTIONs.isreal = 1;
OPTIONS.tol=1e-12;
OPTIONS.maxit=25;
OPTIONS.disp=0;
%tic;toc;

tic
[v,d] = eigs(A,nv,SIGMA,OPTIONS);
%,OPTIONS);
toc
d = abs(diag(d));

for j=1:nv,
  v(:,j) = v(:,j).*ds';
end

