function img = pgmread(filename,size)
% function img = pgmread(filename)
%   this is my version of pgmread for the pgm file created by XV.
%   
%  this program also corrects for the shifts in the image from pm file.

fid = fopen(filename,'r');

for j=1:4,
 a = fgetl(fid);
end

img = fscanf(fid,'%d',size);
img = img';

