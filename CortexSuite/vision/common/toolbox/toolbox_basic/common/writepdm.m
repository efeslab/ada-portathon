function writepfm(name,I)
%
%  writepfm(name,I)
%
  [nr,nc] = size(I);

  fid = fopen(name, 'w');
  fprintf(fid, '%d %d\n', nr,nc);
  fprintf(fid,'%d ',I');
  fclose(fid);

