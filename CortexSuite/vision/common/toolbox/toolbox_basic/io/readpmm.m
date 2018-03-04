function I=readpmm(name)
%
%   I=writepmm(name)
%
%     I is a mul-band image
%
  fid = fopen(name,'r');

  if (fid <0),
    error(sprintf('can not find file %s',name));
  end

  a = fscanf(fid,'%d',3);
  nr = a(1);nc = a(2);nb = a(3);


  I = fscanf(fid, '%f\n', nr*nc*nb);

  I = reshape(I,nc,nr,nb)';
  I = squeeze(I);

  fclose(fid);
