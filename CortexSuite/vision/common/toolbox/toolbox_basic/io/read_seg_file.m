function [seg_map,seg] = read_seg(filename)
%
% function seg = read_seg(filename)
%

fid = fopen(filename,'r');
if (fid < 0),
   error(sprintf('can not find file: %s',filename));
end

header_done =0;
while ~header_done,

   cmt = fgets(fid);
   if length(findstr(cmt,'#')) ~=1,
    header_done = 1;
    cmt = fgets(fid);
    nc = sscanf(cmt,'width %d\n');
    cmt = fgets(fid);
    nr = sscanf(cmt,'height %d\n');
    cmt = fgets(fid);
    mseg = sscanf(cmt,'segments %d\n');
    cmt = fgets(fid);
   end
end

seg = fscanf(fid,'%d',100*nr);
tmp = length(seg(:))/4;
seg = reshape(seg,4,tmp)';

seg_map = zeros(nr,nc);

for j=1:tmp,
  seg_map(seg(j,2)+1,1+seg(j,3):1+seg(j,4)) = seg(j,1);
end
 
