function [img,sizeinfo] = pgmread(filename)
% function img = pgmread(filename)
%   this is my version of pgmread for the pgm file created by XV.
%   
%  this program also corrects for the shifts in the image from pm file.


fname_header = sprintf('%s.h01',filename);
fname_data = sprintf('%s.i01',filename);

fid = fopen(fname_header,'r');


done = 0;
while done~=3,
  cmt = fgets(fid)
  if (findstr(cmt,'!matrix size[1]')),
    nc = sscanf(cmt,'!matrix size[1] :=%d');
    done = done+1;
  elseif (findstr(cmt,'!matrix size[2]')),
    nr = sscanf(cmt,'!matrix size[2] :=%d');
    done = done+1;
  elseif (findstr(cmt,'!matrix size[3]')),
    ns = sscanf(cmt,'!matrix size[3] :=%d');
    done = done+1;
  end
end
fclose(fid);

fid = fopen(fname_data,'r');

%img = fscanf(fid,'%d',size);
%img = img';

img = fread(fid,nc*nr*ns,'uint8');
img = reshape(img,nc,nr,ns);

sizeinfo(1) = nr;
sizeinfo(2) = nc;
sizeinfo(3) = ns;

fclose(fid);
