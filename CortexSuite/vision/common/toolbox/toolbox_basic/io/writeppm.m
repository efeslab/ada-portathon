function writeppm(name,I)

  [y,x,nb] = size(I);

  fid = fopen(name, 'w');
  fprintf(fid, 'P6\n%d %d\n255\n', x,y);

  I1 = reshape(I(:,:,1)',1,x*y);
  I2 = reshape(I(:,:,2)',1,x*y);
  I3 = reshape(I(:,:,3)',1,x*y);
  
  fwrite(fid, [I1;I2;I3], 'uint8');
  fclose(fid);

