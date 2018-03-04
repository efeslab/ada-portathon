function [v,d] = eig_decomp(A)

ds = sum(A);
ds = ones(size(ds))./sqrt(ds);
D1 = ds'*ones(1,length(ds));
A = D1'.*A.*D1;

disp(sprintf('computing eig values'));
tic;[v,d] = eig(A);toc;

d = abs(diag(d));
[tmp,idx] = sort(-d);
d = d(idx);
v = v(:,idx);
v = D1.*v;
