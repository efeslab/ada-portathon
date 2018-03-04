%% set path for the MNcut code

if 1,
%   MNcutDir = '/home/jshi/Matlab/Toolbox/MultiNcut';
  MNcutDir = 'C:\qihuizhu\Checkout\Human\Source\MultiNcut_new\MultiNcut';
  path(path,MNcutDir);
end

%% set the image input and output dir.
% imagedir = '/data/jshi/DLIB/image.cd';
% imagedir = 'C:\qihuizhu\Checkout\Human\Source\Data\test';
imagedir = 'C:\qihuizhu\Checkout\Human\Data\Current\baby_case5';
% imageformat = 'ppm';
imageformat = 'tif';

% OutputDir = '/home/jshi/Results_DLIB';
% OutputDir = 'C:\qihuizhu\Checkout\Human\Source\Data\test';
OutputDir = 'C:\qihuizhu\Checkout\Human\Result\Segmentation\MultiNcut_new_03.07';

a = dir(OutputDir);
if (length(a) == 0), 
  cm = sprintf('mkdir %s',OutputDir); 
  disp(cm); eval(cm);
end

files = dir(sprintf('%s/*.%s',imagedir,imageformat));

%% image size definition
imageSize = 400;

% for id =11:200,	
for id = 1:length(files)
   %for id = 19:19,
    I=readimage(sprintf('%s/%s',imagedir,files(id).name),imageSize);
     
    num_segs = [10, 20];
    
    tic
    [SegLabel,eigenVectors,eigenValues]= MNcut(I,num_segs);
    toc

    for j=1:size(SegLabel,3),
      [gx,gy] = gradient(SegLabel(:,:,j));
      bw = (abs(gx)>0.1) + (abs(gy) > 0.1);
    
      figure(1);clf; J1=showmask(double(I),bw); imagesc(J1);axis image;
      cm = sprintf('print -djpeg %s/file%.4d-%.2d.jpg',OutputDir,id,num_segs(j)); disp(cm);eval(cm);
    

      figure(10);imagesc(SegLabel(:,:,j));axis image;
      cm = sprintf('print -djpeg %s/Seg%.4d-%.2d.jpg',OutputDir,id,num_segs(j));disp(cm);eval(cm);

% pause;
    end

    fname = files(id).name;
    %cm = sprintf('save %s/SegLabl%.4d.mat I SegLabel fname',OutputDir,id); disp(cm);    eval(cm);
    %cm = sprintf('save %s/SegEig%.4d.mat eigenVectors eigenValues',OutputDir,id);disp(cm); eval(cm);
    
end
