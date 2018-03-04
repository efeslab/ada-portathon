function im5(data,nr,nc,mag)

if nargin == 4,
for j=1:size(data,3),
   subplot(nr,nc,j);
   imagesc(data(:,:,j)./mag);axis('image');axis('off');colorbar;drawnow;

%   image(150*data(:,:,j));axis('image');axis('off');colorbar;drawnow;
end

else
for j=1:size(data,3),
   subplot(nr,nc,j);
   imagesc(data(:,:,j));axis('image');axis('off');colorbar;drawnow;
end
end
