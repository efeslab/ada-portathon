function imageOut = Filtering(imageIn, rows, cols, kernel, kernelSize)

imageOut = zeros(rows, cols);%initalize output image to all zeros
imageIn = double(imageIn);%convert to double to allow image arithmetic

 intialCol = ((kernelSize+1)/2);
 endCol = round(cols - ((kernelSize+1)/2));
 halfKernel = (kernelSize-1)/2;
 
 initialRow = ((kernelSize+1)/2);
 endRow = (rows - ((kernelSize+1)/2));
 
 %% Start 1-D filtering row-wise first.
 
 for i=initialRow:endRow
     for j=initialCol:endCol
     imageOut(i,j) = sum(imageIn(i,j-halfKernel:j+halfKernel).*kernel)/sum(kernel);%actual filtering step
     end
 end
 
 %% Start 1-D filtering col-wise first.
 
% kernelT = kernel';
% for i=initialRow:endRow
%     for j=initialCol:endCol
%     imageOut(i,j) = sum(imageOut(i-halfKernel:i+halfKernel,j).*kernelT)/sum(kernel);%kernel to be transposed for performing multiplcation
%     end
% end
% 
% %imshow(uint8(imageOut));
