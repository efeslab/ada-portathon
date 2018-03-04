function [img,header] = pgmread(filename)
%
%  [img,header] = pgmread(filename)

[fid, msg] = fopen(filename, 'r');
if fid == -1,
  error(msg)
end

head = [];
good = 0;
while (good == 0) ,
  l = fgetl(fid);
  if (length(l) == 3),
   if (l == '255'),
    good = 1;
    sze = sscanf(header,'%d');
   end
  end
  header= l;
end

img = fread(fid, sze', 'uchar')';
fclose(fid);
