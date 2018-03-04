function I = readimage(fn,maxSize);

Io = imread(fn);
[nr,nc,nb] = size(Io);

if nb>1,
    I = rgb2gray(Io);
else
    I= Io;
end

%maxSize = 400;
if max(nr,nc) > maxSize,
    I = imresize(I,maxSize/max(nr,nc));
end
