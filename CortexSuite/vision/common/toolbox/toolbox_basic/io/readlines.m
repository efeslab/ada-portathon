function [lines,indexes] = readlines(fname)
%
%  [lines,indexes] = readlines(fname)
%   Read Edges points from .Ins file produced by "getlines"
%   lines: a num_pointsx2 matrix of the edge points
%   indexes: the braking point the lines
%

fid = fopen(fname,'r');

done = 0;
lines = [];
indexes = [];

first_line = fscanf(fid,'%s',1);

while (~done),
  num_lines = sscanf(first_line(3:length(first_line)),'%d');
  disp(num_lines);
  indexes = [indexes,num_lines];
  a = fscanf(fid,'%f',[2,num_lines]);
  lines = [lines;a'];

  first_line = fscanf(fid,'%s',1);
  if (first_line == []),
   done = 1;
  end
end

  
