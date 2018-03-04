function pyr=getPyramid(img, level)
kernel=[1/16,1/4,3/8,1/4,1/16];
pyr=cell(level,1);
pyr{1}=double(img);
for i=2:level
%    imgBlur=conv2(pyr{i-1}, kernel, 'same');
%    imgBlur=conv2(imgBlur, kernel, 'same');
%    pyr{i}=imgBlur(1:2:end, 1:2:end);
    pyr{i}=calcResizedImgMex(pyr{i-1});
end
