function [imageOut] = imageResize(imageIn)

 imageIn = double(imageIn);
 imsize = size(imageIn);
 rows = imsize(1);
 cols = imsize(2);
 
 %% level 1 is the base image.
 
 outputRows = floor((rows+1)/2);
 outputCols = floor((cols+1)/2);
 
 kernel = [1,4,6,4,1];
 kernelSize = 5;
 
 temp = zeros(rows, outputCols);%initalize output image to all zeros
 imageOut = zeros(outputRows, outputCols);%initalize output image to all zeros
 imageIn = double(imageIn);%convert to double to allow image arithmetic
 
 initialCol = 3;        %((kernelSize+1)/2);
 endCol = cols - 2;     %round(cols - ((kernelSize+1)/2));
 halfKernel = 2;        %(kernelSize-1)/2;
 
 initialRow = 3;        %((kernelSize+1)/2);
 endRow = rows - 2;     %(rows - ((kernelSize+1)/2));

 %% Start 1-D filtering row-wise first.
 
 for i=initialRow:endRow
     k = 1;
     for j=initialCol:2:endCol
         temp(i,k) = sum(imageIn(i,j-halfKernel:j+halfKernel).*kernel)/sum(kernel);%actual filtering step
         k = k+1;
     end
 end
 
 %imshow(uint8(temp));
 
 %% Start 1-D filtering col-wise first.
% 
 kernelT = kernel';
 j = 1;
 for i=initialRow:2:endRow
     for k=1:outputCols
         imageOut(j,k) = sum(temp(i-halfKernel:i+halfKernel,k).*kernelT)/sum(kernel);%kernel to be transposed for performing multiplcation
     end
     j = j + 1;
 end
 
% %imshow(uint8(imageOut));
