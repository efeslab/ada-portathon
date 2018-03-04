addpath ~/Matlab/Toolbox/lagrcv/
addpath ~/Matlab/Toolbox/toolbox_basic/filter
addpath ~/Matlab/Toolbox/ikkjin/

N_FEA=1600;
WINSZ=8; %size of sum-up window
NO_PYR=2;
SUPPRESION_RADIUS=10;
LK_ITER=20;
IMAGE_DIR='~/backup/Research/ant/Transport/'
filelist=dir(fullfile(IMAGE_DIR, '*.jpg'));
flen=length(filelist);

img_idx_cur=[1:flen];

%subplot(1,2,1);imshow(Iprev)
%/hold on
%//scatter(features(2,:),features(1,:),'r')
%%
imgName=fullfile(IMAGE_DIR,filelist(img_idx_cur(1)).name);
Icur=imread(imgName);
Icur=rgb2gray(Icur);
Icur=calcImgBlurMex(double(Icur));
%%

Jpyr=getPyramid(Icur, 2);

[lambda tr det c_xx c_xy c_yy] =calcTextureMex(double(Icur), WINSZ);
imgsz=size(lambda);
lambda([1:8 end-8:end],:)=0;
lambda(:,[1:8 end-8:end])=0;
[temp idx]=sort(lambda(:), 'descend');

%%
featureIdx=idx(1:N_FEA);
features=zeros(3, N_FEA);
features(1,:)=ceil(featureIdx/imgsz(1));
features(2,:)=featureIdx'-(features(1,:)-1)*imgsz(1);
features(3,:)=lambda(featureIdx);

imagesc(lambda); hold on
scatter(features(1,:), features(2,:), 'r+');hold off
%%
interestPnt=getANMS(features(1,:)', features(2,:)', features(3,:)', SUPPRESION_RADIUS);
interestPnt=interestPnt';
scatter(interestPnt(1,:), interestPnt(2,:), 'g+')
%%
features=interestPnt(1:2,:);
%%

for iter=img_idx_cur
    Iprev=Icur;
    Icur=imread(fullfile(IMAGE_DIR,filelist(img_idx_cur(iter)).name));      
    Icur=rgb2gray(Icur);
    Icur=calcImgBlurMex(double(Icur));
    
    Ipyr=Jpyr;
    Jpyr=getPyramid(Icur, 2);

    [dxPyr dyPyr]=calcSobelPyrMex(Ipyr,2);

    [lambda tr det c_xx c_xy c_yy] =  calcTexturePyrMex(dxPyr, dyPyr, WINSZ, NO_PYR);

    [newpoints status]=calcOptFlowLKPyrMex(Ipyr, dxPyr, dyPyr, Jpyr, double(features), 4, 0.03, LK_ITER, c_xx, c_xy, c_yy); 

    newpoints=newpoints(:,find(status));
    figure(1);
    imagesc(Icur);colormap gray
    hold on;scatter(newpoints(1,:), newpoints(2,:), 'r+'); hold off;    
    drawnow
    %print('-djpeg', sprintf('result/result_%03d', iter))    
    %pause
    features=newpoints;    
end
