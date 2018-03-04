% MNcutDemo.m
% created by song, 06/13/2005
%  an exmaple of how to use and display MNcut

num_segs = [20];
imageSize = 800;

img_filename = '/u/ikkjin/Benchmark/stitch/data/test/capitol/img1.jpg';

I=readimage(img_filename,imageSize);

[SegLabel,eigenVectors,eigenValues]= MNcut(I,num_segs);

for j=1:size(SegLabel,3),
    [gx,gy] = gradient(SegLabel(:,:,j));
    bw = (abs(gx)>0.1) + (abs(gy) > 0.1);

    figure(1);clf; J1=showmask(double(I),bw); imagesc(J1);axis image; axis off;
    set(gca, 'Position', [0 0 1 1]);

    %      cm = sprintf('print -djpeg %s/file%.4d-%.2d.jpg',OutputDir,id,num_segs(j)); disp(cm);eval(cm);


    %      figure(10);imagesc(SegLabel(:,:,j));axis image; axis off;
    %      set(gca, 'Position', [0 0 1 1]);
    %      cm = sprintf('print -djpeg %s/Seg%.4d-%.2d.jpg',OutputDir,id,num_segs(j));disp(cm);eval(cm);

    % pause;
end

% fname = files(id).name;
%cm = sprintf('save %s/SegLabl%.4d.mat I SegLabel fname',OutputDir,id); disp(cm);    eval(cm);
%cm = sprintf('save %s/SegEig%.4d.mat eigenVectors eigenValues',OutputDir,id);disp(cm); eval(cm);

