function [dstImg] = getInterpolatePatch(srcImg,rows, cols,centerX,centerY,winSize)

a=centerX-floor(centerX);
b=centerY-floor(centerY);
a11=(1-a)*(1-b);
a12=a*(1-b);
a21=(1-a)*b;
a22=a*b;

for i=-winSize:winSize-1
	srcIdxx=floor(centerY)+i;
	dstIdxx=i+winSize+1;
	for j=-winSize:winSize-1
		srcIdx = srcIdxx * cols + floor(centerX) + j;
   		dstIdx = dstIdxx*2*winSize+j+winSize+1;
		dstImg(dstIdx)=srcImg(srcIdxx, floor(centerX)+j)*a11;
        dstImg(dstIdx)= dstImg(dstIdx) + srcImg(srcIdxx, floor(centerX)+j+1)*a12;
        dstImg(dstIdx)= dstImg(dstIdx) + srcImg(srcIdxx+1, floor(centerX)+j)*a21;
        dstImg(dstIdx)= dstImg(dstIdx) + srcImg(srcIdxx+1, floor(centerX)+j+1)*a22;
    end
end

