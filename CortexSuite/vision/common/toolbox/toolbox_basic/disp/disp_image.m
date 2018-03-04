function disp_image(img,sze,index,mask)

%figure(2)
subplot(sze(1),sze(2),index);

if (size(mask) ~= size(mask)),
 error(['size of image is ',int2str(size(mask)),' size of mask is ',...
        int2str(size(mask))]);
end

img = img-min(min(img));
I = 0*(img.*(~mask)) + img.*mask;
I = img.*mask;
colormap(gray)
imagesc(I);
%axis('off')
axis('equal');
axis('square');
drawnow;
