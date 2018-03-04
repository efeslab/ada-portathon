function [nr,nc] = peek_pgm_size(filename)
% function [nr,nc] = peek_pgm_size(filename)
%   this is my version of pgmread for the pgm file created by XV.
%   
%  this program also corrects for the shifts in the image from pm file.


fid = fopen(filename,'r');
fscanf(fid, 'P5\n');
cmt = '#';
while findstr(cmt, '#'),
  cmt = fgets(fid);
   if length(findstr(cmt, '#')) ~= 1,
      YX = sscanf(cmt, '%d %d');
      nc = YX(1); nr = YX(2);
   end
end

fclose(fid);
