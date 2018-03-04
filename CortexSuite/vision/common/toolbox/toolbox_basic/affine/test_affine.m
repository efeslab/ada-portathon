%%% This is a test program for Affine tracker %%%%

disp(sprintf('This is a test program of Affine tracker'));

%% read in images

disp(sprintf('read in images'));
I = readpgm('pan.0.pgm');
J = readpgm('pan.1.pgm');

figure(1); im(I); colormap(gray);
figure(2); im(J); colormap(gray);


figure(1);disp(sprintf('click on the center of a image window'));
c = round(ginput(1));

%% compute the displacement of that image window
disp(sprintf('computing...'));

win_hsize_temp = [8,8];
w = 3;
num_iter = 6;

disp_flag = 1;

win_h = win_hsize_temp + [w,w];
if disp_flag == 1,
  figure_id = 3;
  [A,D,mask] = compute_AD_disp(I,J,c,c,win_h,num_iter,w,figure_id);
else
  [A,D,mask] = compute_AD(I,J,c,c,win_h,num_iter,w);
end
