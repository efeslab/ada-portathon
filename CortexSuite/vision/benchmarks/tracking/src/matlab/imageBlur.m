function imageOut = imageBlur(imageIn)

imsize = size(imageIn);
rows = imsize(1);
cols = imsize(2);

imageOut = zeros(rows, cols);%initalize output image to all zeros
imageIn = double(imageIn);%convert to double to allow image arithmetic

kernel = [1 4 6 4 1];
kernelSize = 5;

startCol = 3;       %((kernelSize+1)/2);
endCol = cols - 2;  %round(cols - ((kernelSize+1)/2));
halfKernel = 2;     %(kernelSize-1)/2;

startRow = 3;       %((kernelSize+1)/2);
endRow = rows - 2;  %(rows - ((kernelSize+1)/2));

%% Start 1-D filtering row-wise first.

tempOut = zeros(rows, cols);%initalize temp image to all zeros
for i=startRow:endRow
    for j=startCol:endCol
        tempOut(i,j) = sum(imageIn(i,j-halfKernel:j+halfKernel).*kernel)/sum(kernel);%actual filtering step
    end
end

%% Start 1-D filtering col-wise first.

for i=startRow:endRow
    for j=startCol:endCol
    imageOut(i,j) = sum(tempOut(i-halfKernel:i+halfKernel,j).*kernel')/sum(kernel);%kernel to be transposed for performing multiplcation
    end
end

