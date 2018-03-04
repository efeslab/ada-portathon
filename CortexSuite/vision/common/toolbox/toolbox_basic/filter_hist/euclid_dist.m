function [A,mag] = euclid_dist(v)



A = 2*v*v';

nv = size(v,2);
if (nv>1)
 mag = sum((v.*v)')';
else
 mag = v.*v;
end

np = length(mag);

for j=1:np,
  A(:,j) = mag-A(:,j);
end

for j=1:np,
  A(j,:) = mag' + A(j,:);
end
