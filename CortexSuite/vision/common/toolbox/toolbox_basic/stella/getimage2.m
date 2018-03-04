% function f = getimage2(imagefile) returns a normalized intensity image.
% If the file postfix is not given, then I will search any possible image file
% under the IMAGE_DIR.

% Stella X. Yu, March 1999

function f = getimage2(imagefile)

if exist(imagefile)==2,
   g = {imagefile};
else
   g = {};
end
globalenvar;
g = [g; getfnames(IMAGE_DIR,[imagefile,'.*'])];

j = 1;
for i=1:length(g),
   k = findstr(g{i},'.');
   gp = g{i}(k(end)+1:end);
   if strcmp(gp,'ppm'),
      f = double(readppm(g{i}));
      j = 0;
   elseif sum(strcmp(gp,{'jpg','tif','jpeg','tiff','bmp','png','hdf','pcx','xwd'}))>0,
      f = double(imread(g{i}));
      j = 0;
   end
   if j==0,
      disp(sprintf('This is an image read from %s under %s',g{i},IMAGE_DIR));
      break;
   end
end
if j,
   f = [];
   disp('Image not found');
   return;
end
         
if size(f,3)>1,
    %f = sum(f,3)./3;
   f = rgb2ntsc(f);
   f = f(:,:,1);
end
minf = min(f(:));
maxf = max(f(:));
f = (f - minf) ./ (maxf - minf);
