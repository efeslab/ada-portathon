data_dir = '/data/insecure/qihuizhu/baseball/Gray/train/';
save_dir = '/home/songgang/project/MultiNcut/batch_result_MNcut';

num_segs = [20];
imageSize = 200;


filelist = dir(fullfile(data_dir, '*.tif'));

nb_file = max(size(filelist));


tic;
for ii = 1:nb_file
    fprintf(2, 'Segmenting image: %s ...\n', filelist(ii).name);

    img_filename = fullfile(data_dir, filelist(ii).name);
    I=readimage(img_filename,imageSize);
    
    
    [SegLabel,eigenVectors,eigenValues]= MNcut(I,num_segs);

    for j=1:size(SegLabel,3),
        [gx,gy] = gradient(SegLabel(:,:,j));
        bw = (abs(gx)>0.1) + (abs(gy) > 0.1);

        figure(1);clf; J1=showmask(double(I),bw); imagesc(J1);axis image; axis off;
        set(gca, 'Position', [0 0 1 1]);
        set(gca, 'Position', [0 0 1 1]);
        [PATHSTR,NAME,EXT,VERSN] = fileparts(filelist(ii).name);
        print('-f1', '-djpeg90', fullfile(save_dir, sprintf('%s%s-%d.jpg', NAME,'-out', num_segs(j))));


        %      cm = sprintf('print -djpeg %s/file%.4d-%.2d.jpg',OutputDir,id,num_segs(j)); disp(cm);eval(cm);


        %      figure(10);imagesc(SegLabel(:,:,j));axis image; axis off;
        %      set(gca, 'Position', [0 0 1 1]);
        %      cm = sprintf('print -djpeg %s/Seg%.4d-%.2d.jpg',OutputDir,id,num_segs(j));disp(cm);eval(cm);

%        keyboard;
    end



end;
toc;
fprintf(2, ' %d files done\n', nb_file);
