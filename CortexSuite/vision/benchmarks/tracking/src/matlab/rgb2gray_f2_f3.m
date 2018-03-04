%! _rgb2gray_f2_f3

function grayImage = rgb2gray_f2_f3(colorImage)

%0.2989 * R + 0.5870 * G + 0.1140 * B
rows = size(colorImage, 1);
cols = size(colorImage, 2);
rgb = size(colorImage, 3);

grayImage = zeros(rows, cols);
for i = 1:rows
    for j = 1:cols
        grayImage(i,j) = 0.2989 * colorImage(i,j,1) + 0.5870 * colorImage(i,j,2) + 0.1140 * colorImage(i,j,3);
    end
end
    