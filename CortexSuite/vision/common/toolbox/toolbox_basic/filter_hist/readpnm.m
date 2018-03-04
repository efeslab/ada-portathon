function I = readpnm(name)

  fid = fopen(name, 'r');
  fscanf(fid, 'P5\n');
  cmt = '#';
  while findstr(cmt, '#') == 1
    cmt = fgets(fid);
    if findstr(cmt, '#') ~= 1
      YX = sscanf(cmt, '%d %d %d');
      y = YX(1); x = YX(2); nb = YX(3);
    end
  end
  fgets(fid); 
  packed = fscanf(fid,'%f',[nb*y*x]);

  for j = 1:nb,
	I(:,:,j) = reshape(packed(j:nb:nb*y*x),y,x)';
  end

  fclose(fid);

