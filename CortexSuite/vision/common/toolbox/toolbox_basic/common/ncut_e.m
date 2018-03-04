function [v,d] = ncut(A,nv)
%
%  [v,d] = ncut(A,nv)
%
%    computes 'nv' of the normalized cut vectors 'v' from
%    matrix 'A'
%

%
%  Jianbo Shi   
%

ds = sum(A);
D = diag(ds);

ds = ones(size(ds))./sqrt(ds);

B = D-A;

for j=1:size(A,1),
  B(j,:) = B(j,:).*ds;
end

for j=1:size(A,2);
  B(:,j) = B(:,j).*ds';
end

disp(sprintf('computing eig values'));
tic;[v,d] = eigs(B,nv,'sm');toc;

d = abs(diag(d));

for j=1:nv,
  v(:,j) = v(:,j).*ds';
end

