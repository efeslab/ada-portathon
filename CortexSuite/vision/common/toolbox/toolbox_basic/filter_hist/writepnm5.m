function writepnm5(name,I)
%
%   writepnm5(name,I)
%
%     I is a mul-band image
%

  [nr,nc,nb] = size(I);

  fid = fopen(name,'w');

  fprintf(fid, 'P5\n%d %d %d\n255\n', nc,nr,nb);

  n = nr*nc;

  J = [];

  for j=1:nb,
      J = [J,reshape(I(:,:,j)',n,1)];
  end

  J = reshape(J',nb*n,1);
  
  fprintf(fid,'%f ',J);
  fclose(fid);

