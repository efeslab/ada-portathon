function [Dx, Dy] = calcSobel(imageIn)

imsize = size(imageIn);
rows = imsize(1);
cols = imsize(2);

Dx = zeros(rows, cols);     %initalize output image to all zeros
Dy = zeros(rows, cols);     %initalize output image to all zeros
imageIn = double(imageIn);  %convert to double to allow image arithmetic

kernel_1 = [1 2 1];
kernel_2 = [1 0 -1];
kernelSize = 3;

sum_kernel_1 = 4;
sum_kernel_2 = 2;

startCol = 2;           %((kernelSize+1)/2);
endCol = cols - 1;      %round(cols - ((kernelSize+1)/2));
halfKernel = 1;         %(kernelSize-1)/2;

startRow = 2;           %((kernelSize+1)/2);
endRow = rows - 1;      %(rows - ((kernelSize+1)/2));

%imshow(uint8(imageIn));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Calculate Gx (gradient in X-dir)
%% Gx = ([1 2 1]') * ([1 0 -1] * imageIn)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Start 1-D filtering row-wise first.

tempOut = zeros(rows, cols);%initalize temp image to all zeros
for i=startRow:endRow
   for j=startCol:endCol
       tempOut(i,j) = sum(imageIn(i,j-halfKernel:j+halfKernel).*kernel_2)/sum_kernel_2;%actual filtering step
   end
end

% Start 1-D filtering col-wise first.

for i=startRow:endRow
   for j=startCol:endCol
       Dx(i,j) = sum(tempOut(i-halfKernel:i+halfKernel,j).*kernel_1')/sum_kernel_1;%kernel to be transposed for performing multiplcation
       Dx(i,j) = Dx(i,j);% + 128;
   end
end


%imshow(uint8(Dx));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Calculate Gy (gradient in Y-dir)
%% Gy = ([1 0 -1]') * ([1 2 1] * imageIn)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Start 1-D filtering row-wise first.

for i=startRow:endRow
    for j=startCol:endCol
        tempOut(i,j) = sum(imageIn(i-halfKernel:i+halfKernel,j).*kernel_2')/sum_kernel_2;%kernel to be transposed for performing multiplcation
    end
end

for i=startRow:endRow
    for j=startCol:endCol
        Dy(i,j) = sum(tempOut(i,j-halfKernel:j+halfKernel).*kernel_1)/sum_kernel_1;
    end
end


%imshow(uint8(Dy));
