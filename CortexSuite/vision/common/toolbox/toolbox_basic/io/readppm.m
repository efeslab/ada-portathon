function [I,r, g, b] = readppm(name)

  fid = fopen(name, 'r');
  fscanf(fid, 'P6\n');
  cmt = '#';
  while findstr(cmt, '#'),
    cmt = fgets(fid);
    if length(findstr(cmt, '#')) ~= 1
      YX = sscanf(cmt, '%d %d');
      y = YX(1); x = YX(2);
    end
  end
  fgets(fid); 
  packed = fread(fid,[3*y,x],'uint8')';
  r = packed(:,1:3:3*y);
  g = packed(:,2:3:3*y);
  b = packed(:,3:3:3*y);
  fclose(fid);

 I(:,:,1) = r;
 I(:,:,2) = g;
 I(:,:,3) = b;
 I  =  I/255;
