function [v,d] = ncut(A,nv)
%
%  [v,d] = ncut(A,nv)
%
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
ds = ones(size(ds))./sqrt(ds);

for j=1:size(A,1),
  A(j,:) = A(j,:).*ds;
end

for j=1:size(A,2);
  A(:,j) = A(:,j).*ds';
end


%disp(sprintf('computing eig values'));
OPTIONS.tol=1e-10;
OPTIONS.maxit=15;
OPTIONS.disp=0;
%tic;toc;

[v,d] = eigs(A,nv,OPTIONS);

d = abs(diag(d));

for j=1:nv,
  v(:,j) = v(:,j).*ds';
end

