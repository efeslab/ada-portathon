function I = readpdm(filename)

fid = fopen(filename,'r');

A = fscanf(fid,'%d',3)
A(3) = max(1,A(3));

I = fscanf(fid,'%d',[A(1)*A(2)*A(3)]);

%I = fscanf(fid,'%f',A(2)*A(1));I = reshape(I,A(1),A(2));

I = reshape(I,A(2),A(1),A(3));

I = permute(I,[2,1,3]);

fclose(fid);
