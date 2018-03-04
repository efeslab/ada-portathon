function I = readpcm(filename)

fid = fopen(filename,'r');

A = fscanf(fid,'%d\n',2);
I = fscanf(fid,'%c',A(2)*A(1));
I = I';
I = str2num(I);
I = reshape(I,A(2),A(1))';


fclose(fid);