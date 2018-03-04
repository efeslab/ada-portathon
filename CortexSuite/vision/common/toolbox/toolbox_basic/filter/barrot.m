img1 = gifread('color010.gif');
img1 = img1(220:350,1:200);    
img2 = gifread('color-avg.gif');
img2 = img2(220:350,1:200); 

sigx = 3;
sigy = 3;
siz = 8;
angles = 0:19:179;

[Imag1,Iangle1] = brute_force_angle(img1,sigx,sigy,siz,angles);
[Imag2,Iangle2] = brute_force_angle(img2,sigx,sigy,siz,angles);

tresh = max(max(Imag1))*0.1
D = angle_diff(Imag1,Iangle1,Imag2,Iangle2,tresh);
subplot(2,2,1); imagesc(Iangle1*180/pi); colorbar;          
subplot(2,2,2); imagesc(Iangle2*180/pi); colorbar;          
subplot(2,2,3); imagesc(D*180/pi); colorbar;          
subplot(2,2,4); imagesc(Imag1); colorbar;
colormap(jet)
          

