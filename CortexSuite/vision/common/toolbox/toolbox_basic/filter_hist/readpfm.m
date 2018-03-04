function I = readpfm(filename)

fid = fopen(filename,'r');

A = fscanf(fid,'%d',2);
I = fscanf(fid,'%f',[A(1),A(2)]);

%I = fscanf(fid,'%f',A(2)*A(1));I = reshape(I,A(1),A(2));

fclose(fid);
