function I = read_pfm(filename)

fid = fopen(filename,'r');

A = fscanf(fid,'%d',2)
I = fscanf(fid,'%f',[A(1),A(2)]);


I = I';
size(I);
fclose(fid);
