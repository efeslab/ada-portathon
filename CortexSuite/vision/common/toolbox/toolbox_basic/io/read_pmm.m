function I = read_pmm(fname)

fid = fopen(fname,'r');

[A] = fscanf(fid,'%d\n',3);

I = fscanf(fid,'%d',prod(A));


I = reshape(I,A(2),A(1))';

I = squeeze(I);
