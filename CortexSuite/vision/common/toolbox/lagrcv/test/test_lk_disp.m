addpath /u/ikkjin/Matlab/Toolbox/lagrcv

%Iprev=imread('/Projects/LAGR/logs/Test5/left_APIrun530-1/l24Aug05-abacination-1124876208.403311.ppm');
%Icur=imread('/Projects/LAGR/logs/Test5/left_APIrun530-1/l24Aug05-abacination-1124876208.670013.ppm');
Iprev=imread('img0.ppm');
Icur=imread('img1.ppm');

Iprev=rgb2gray(Iprev);
Icur=rgb2gray(Icur);

tic
 [ features numvalid ] = goodFeaturesToTrack(Iprev, 0.3, 10);
toc
subplot(1,2,1);imshow(Iprev)
hold on
scatter(features(2,:),features(1,:),'r')

Ipyr=getPyramid(Iprev, 3);
Jpyr=getPyramid(Icur, 3);
tic
[dxPyr2 dyPyr2]=calcGradientPyrMex(Ipyr,3);
toc
tic
[dxPyr dyPyr]=calcSobelPyrMex(Ipyr,3);
toc

features=features(:,1:211);
for i=20
 features2=[features(2,:); features(1,:)];
tic
 [ newpoints status pyr1 ] = calcOpticalFlowPyrLK(Iprev,Icur,features, i);    
toc
tic
 [newpoints2 status]=calcOptFlowLKPyrMex(Ipyr, dxPyr, dyPyr, Jpyr, double(features2), 4, 0.03, i); 
toc
 newpoints2=[newpoints2(2,:); newpoints2(1,:)];
features_out=features(:,find(status));
newpoints=newpoints(:,find(status));
newpoints2=newpoints2(:,find(status));
subplot(1,2,1);imshow(Iprev);hold on
quiver(features_out(2,:),features_out(1,:), newpoints(2,:)-features_out(2,:), newpoints(1,:)-features_out(1,:),0,'r');hold off
subplot(1,2,2);imshow(Iprev);hold on
quiver(features_out(2,:),features_out(1,:), newpoints2(2,:)-features_out(2,:), newpoints2(1,:)-features_out(1,:),0,'r');hold off
%subplot(1,2,2);imshow(Icur);hold on
%scatter(newpoints2(2,:),newpoints2(1,:),'r');hold off
%sum(sum((newpoints-newpoints2).^2))

pause
end
