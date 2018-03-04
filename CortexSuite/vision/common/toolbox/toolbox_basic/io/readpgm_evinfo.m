function [img,ev_info] = pgmread_evinfo(filename)
% function img = pgmread(filename)
%   this is my version of pgmread for the pgm file created by XV.
%
%   return the information in line # 


fid = fopen(filename,'r');

if (fid <0),
  error(sprintf('can not find file %s',filename));
end

fscanf(fid, 'P5\n');
cmt = '#';
while findstr(cmt, '#'),
  cmt = fgets(fid);
  if findstr(cmt,'#'),
      ev_info = sscanf(cmt,'# minv: %f, maxv: %f, scale: %f, eigval: %f');
  end   
  if length(findstr(cmt, '#')) ~= 1,
      YX = sscanf(cmt, '%d %d');
      y = YX(1); x = YX(2);
  end
end

fgets(fid);

%img = fscanf(fid,'%d',size);
%img = img';

img = fread(fid,[y,x],'uint8');
img = img';
fclose(fid);

