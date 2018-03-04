function I = imread2(fname,im_dir);
%
%  I = imread2(fname,im_dir);
%

cur_dir = pwd;

if nargin>1,
  cd(im_dir);
end

%%% put on the necessary extension
d = dir(fname);

if isempty(d),
  d = dir([fname,'*']);
end

if isempty(d),
  I = [];
else

  fname = d.name;
  
  %%% find extension
  k = findstr(fname,'.');
  ext = fname(k(end)+1:end);

  if (ext == 'bz2'),
    cm = sprintf('!bzip2 -d %s',fname);
    disp(cm);eval(cm);
    I = imread2(fname(1:k(end-1)-1));
    cm = sprintf('!bzip2 %s',fname(1:k(end)-1));
		 disp(cm);eval(cm);
  elseif (ext == 'ppm');
    I = readppm(fname);
  elseif (ext == 'pgm');
    I = readpgm(fname);
  else
    I = imread(fname);
I = double(I)/255;
  end
end

cd(cur_dir);
