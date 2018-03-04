function I = readpfm(filename)

fid = fopen(filename,'r');

A = fscanf(fid,'%d',2);
I = fscanf(fid,'%d',[A(1),A(2)]);

fclose(fid);
