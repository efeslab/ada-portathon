function W2 = renormalize(W,nstep)
%
%  keep renormalizing until W is almost double
%  stocastic
%

if nargin<2,
 nstep = 5;
end

n_node = size(W,1);

for j=1:nstep,
 fprintf(',');
 % normalize row 
 D = sum(W,2);
 D = 1./(D+eps);
 W = W.*D(:,ones(1,n_node));
 
 % normlize column
 D = sum(W,1);
 D = 1./(D+eps);
 W = W.*D(ones(n_node,1),:);
end
fprintf('\n');

 D = sum(W,2);
 D = 1./(D+eps);
 W2 = W.*D(:,ones(1,n_node));


 
