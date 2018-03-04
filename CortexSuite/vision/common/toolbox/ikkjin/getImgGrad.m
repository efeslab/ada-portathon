function Ig=getImgGrad(imgroi)
im = double(rgb2gray(imgroi));
g1 = fspecial('gaussian', 9,1);  % Gaussian with sigma_d
img1 = conv2(im,g1,'same');  % blur image with sigma_d
Ix = conv2(img1,[-1 0 1],'same');  % take x derivative
Iy = conv2(img1,[-1;0;1],'same');  % take y derivative
Ig=Ix.^2+Iy.^2;