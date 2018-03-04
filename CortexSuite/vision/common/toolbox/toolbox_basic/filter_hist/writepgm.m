function I = writepgm(name,I)

  [y,x] = size(I);

  fid = fopen(name, 'w');
  fprintf(fid, 'P5\n%d %d\n255\n', x,y);
  fwrite(fid, I', 'uint8');
  fclose(fid);
