addpath ~/Matlab/Toolbox/lagrcv/
addpath ~/Matlab/Toolbox/toolbox_basic/filter
addpath ~/Matlab/Toolbox/ikkjin/

IMAGE_DIR='/data/insecure/images/ants/Transport/'
filelist=dir(fullfile(IMAGE_DIR, '*.jpg'));
flen=length(filelist);

img_idx_cur=[1:flen];

%subplot(1,2,1);imshow(Iprev)
%/hold on
%//scatter(features(2,:),features(1,:),'r')
%Iprev=imread(fullfile(IMAGE_DIR,filelist(img_idx_prev(1)).name));
%%
imgName=fullfile(IMAGE_DIR,filelist(img_idx_cur(1)).name);
Icur=imread(imgName);
%%
Icur=smooth(double(rgb2gray(Icur)), 4);
%%
Icur=Icur(1:2:end,1:2:end);

[ features numvalid ] = goodFeaturesToTrack(Icur, 0.3, 10);
features=features(:,1:numvalid);

figure(1);
imagesc(Icur);colormap gray
hold on;scatter(features(2,:), features(1,:), 'r+'); hold off;

%%
for iter=img_idx_cur
    Iprev=Icur;
    Icur=imread(fullfile(IMAGE_DIR,filelist(img_idx_cur(iter)).name));      
    Icur=calcImgBlurMex(rgb2gray(Icur));
    
    tic
        [ newpoints status pyr1 ] = calcOpticalFlowPyrLK(Iprev,Icur,features);    
    toc
    newpoints=newpoints(:,find(status));
    figure(1);
    imagesc(Icur);colormap gray
    hold on;scatter(newpoints(2,:), newpoints(1,:), 'r+'); hold off;    
    drawnow
    print('-djpeg', sprintf('result/result_%03d', iter))
    %pause
    features=newpoints;
end
