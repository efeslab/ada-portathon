clear

figure(1);colormap(gray);

%------------ Parameters --------------------------
window_size_h = 40;
window_size = 2*window_size_h+1;
noise_level = 40/256;

% define A and D
x_ext = -0.423;
ext = 1.232;
A = [ext+x_ext, 0.2534; 0.3423,ext];

D = [3,1];

%------------- compute image I and J ---------------
disp('generating I')
I_init = gen_feature_s(window_size);
[size_y,size_x] = size(I_init);

%define image center
[center_x,center_y] = find_center(size_x,size_y);

%  adding noise to image I
I = I_init+noise_level*rand(size_y,size_x); 
% make sure all intensities are positive
I = I.*(I>0);

disp('computing J')
J_init = compute_J(A,D,I_init,[center_x,center_y],[window_size_h,window_size_h]);
J = J_init+noise_level*rand(size_y,size_x); 
J = J.*(J>0);


%------------- compute A and residue ----------------
c = [center_x,center_y];
num_iter = 8; w = 9;win_h = [window_size_h,window_size_h];

fig_disp = 1;
[Ac,Dc,mask] = compute_AD_disp(I,J,c,c,win_h,num_iter,w,fig_disp);

