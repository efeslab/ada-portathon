function [v,d] = eig_decomp_v5(A,nv)

ds = sum(A);
ds = ones(size(ds))./sqrt(ds);
D1 = ds'*ones(1,length(ds));
A = D1'.*A.*D1;

disp(sprintf('computing eig values'));
tic;[v,d] = eigs(A,nv);toc;

d = abs(diag(d));

v = D1(:,1:size(v,2)).*v;
