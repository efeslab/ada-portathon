function b = reduce_all(a)

numband = size(a,3);

for j=1:numband,

    b(:,:,j) = reduce(a(:,:,j));
end
