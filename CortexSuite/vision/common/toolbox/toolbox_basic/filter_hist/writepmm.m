function writepmm(name,I)
%
%   writepmm(name,I)
%

  [nr,nc,nb] = size(I);

  fid = fopen(name,'w');

  fprintf(fid, 'P5\n%d %d %d\n255\n', nc,nr,nb);

  fprintf(fid,'%f ',I);
  fclose(fid);

