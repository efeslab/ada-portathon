function J = reduce(I)

[nr,nc,nb] = size(I);
for j=1:nb,
    tmp = gauss_lowpass(I(:,:,j));
    J(:,:,j) = tmp(1:2:nr,1:2:nc);
end