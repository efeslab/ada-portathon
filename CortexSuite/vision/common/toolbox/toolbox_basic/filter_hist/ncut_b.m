function [v,d] = ncut(A,nv)

ds = sum(A);
ds = ones(size(ds))./sqrt(ds);

for j=1:size(A,1),
  A(j,:) = A(j,:).*ds;
end

for j=1:size(A,2);
  A(:,j) = A(:,j).*ds';
end

%D1 = ds'*ones(1,length(ds));
%A = D1'.*A.*D1;

disp(sprintf('computing eig values'));
tic;[v,d] = eigs(A,nv);toc;

d = abs(diag(d));

for j=1:nv,
  v(:,j) = v(:,j).*ds';
end
%v = D1(:,1:size(v,2)).*v;
