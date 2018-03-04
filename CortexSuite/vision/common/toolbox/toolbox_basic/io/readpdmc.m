function I = readpfm(filename)

fid = fopen(filename,'r');

A = fscanf(fid,'%d',2);
I = fscanf(fid,'%d',[A(2),A(1)]);
%I = fscanf(fid,'%d',[300,1000]);
I = I';

%I = fscanf(fid,'%f',A(2)*A(1));I = reshape(I,A(1),A(2));

fclose(fid);
