%%% This code is an additional code that helps doing projector calibration in 3D scanning setup.
%%% This is not a useful code for anyone else but me.
%%% I included it in the toolbox for illustration only.


load camera_results;


proj_name = input('Basename projector calibration images (without number nor suffix): ','s');


i = 1;

while (i <= n_ima), % & (~no_image_file),
   
   if active_images(i),
   
   	%fprintf(1,'Loading image %d...\n',i);
   
   	if ~type_numbering,   
      	number_ext =  num2str(image_numbers(i));
   	else
      	number_ext = sprintf(['%.' num2str(N_slots) 'd'],image_numbers(i));
   	end;
   	
      ima_namep = [proj_name  number_ext 'p.' format_image];
      ima_namen = [proj_name  number_ext 'n.' format_image];
      
      if i == ind_active(1),
         fprintf(1,'Loading image ');
      end;
         
         fprintf(1,'%d...',i);
         
         if format_image(1) == 'p',
            if format_image(2) == 'p',
               Ip = double(loadppm(ima_namep));
               In = double(loadppm(ima_namen));
            else
               Ip = double(loadpgm(ima_namep));
               In = double(loadpgm(ima_namen));
            end;
         else
            if format_image(1) == 'r',
               Ip = readras(ima_namep);
               In = readras(ima_namen);
            else
               Ip = double(imread(ima_namep));
               In = double(imread(ima_namen));
            end;
         end;

      	
   		if size(Ip,3)>1,
      		Ip = Ip(:,:,2);
      		In = In(:,:,2);
   		end;
   
   		eval(['Ip_' num2str(i) ' = Ip;']);
   		eval(['In_' num2str(i) ' = In;']);
      
   end;
   
   i = i+1;   
   
end;


fprintf(1,'\nExtraction of the grid corners on the image\n');

disp('Window size for corner finder (wintx and winty):');
wintx = input('wintx ([] = 5) = ');
if isempty(wintx), wintx = 5; end;
wintx = round(wintx);
winty = input('winty ([] = 5) = ');
if isempty(winty), winty = 5; end;
winty = round(winty);
fprintf(1,'Window size = %dx%d\n',2*wintx+1,2*winty+1);


disp('The projector you are using is the DLP or Intel');
nx = 800;
ny = 600;

dX = input('Size dX in x of the squares (in pixels) [50] = ');
dY = input('Size dY in y of the squares (in pixels) [50] = ');
   
if isempty(dX), dX=50; end;
if isempty(dY), dY=50; end;
   
dXoff = input('Position in x of your reference (in pixels) [399.5] = ');
dYoff = input('Position in y of your reference (in pixels) [299.5] = ');
   
if isempty(dXoff), dXoff=399.5; end;
if isempty(dYoff), dYoff=299.5; end;

end;



for kk = ind_active,
   
   eval(['Ip = Ip_' num2str(kk) ';']);
   eval(['In = In_' num2str(kk) ';']);
   
	[x,X,n_sq_x,n_sq_y,ind_orig,ind_x,ind_y] = extract_grid(In,wintx,winty,fc,cc,kc,dX,dY);
   xproj = x;
   
   Np_proj = size(x,2);
   
	figure(2);
	image(Ip);
	hold on;
	plot(xproj(1,:)+1,xproj(2,:)+1,'r+');
	title('Click on your reference point');
	xlabel('Xc (in camera frame)');
	ylabel('Yc (in camera frame)');
	hold off;
	
	disp('Click on your reference point...');
	
	[xr,yr] = ginput2(1);
	
	err = sqrt(sum((xproj - [xr;yr]*ones(1,Np_proj)).^2));
	ind_ref = find(err == min(err));
	
	ref_pt = xproj(:,ind_ref);
	
	
	figure(2);
	hold on;
	plot(ref_pt(1)+1,ref_pt(2)+1,'go'); hold off;
	
	
	nn = floor(ind_ref/(n_sq_x+1));
	off_x = ind_ref - nn*(n_sq_x+1) - 1;
	off_y = n_sq_y - nn;
	
	
	xprojn = xproj - cc * ones(1,Np_proj);
	xprojn = xprojn ./ (fc * ones(1,Np_proj));
   xprojn = comp_distortion(xprojn,kc);
   
   eval(['Rc = Rc_' num2str(kk) ';']);
   eval(['Tc = Tc_' num2str(kk) ';']);
   
	Zc = ((Rc(:,3)'*Tc) * (1./(Rc(:,3)' * [xprojn; ones(1,Np_proj)])));
	Xcp = (ones(3,1)*Zc) .* [xprojn; ones(1,Np_proj)]; % % in the camera frame
	%Xproj = Rc'* Xcp - (Rc'*Tc)*ones(1,Np); % in the object frame !!! it works!
	%Xproj(3,:) = zeros(1,Np);
   
   eval(['X_proj_' num2str(kk) ' = Xcp;']); % coordinates of the points in the 
   
   x_proj = X(1:2,:) + ([dXoff - dX * off_x ; dYoff - dY * off_y]*ones(1,Np_proj));
   
   eval(['x_proj_' num2str(kk) ' = x_proj;']); % coordinates of the points in the 
   
end;



X_proj = [];
x_proj = [];

for kk = ind_active,
   eval(['X_proj = [X_proj X_proj_' num2str(kk) '];']);
   eval(['x_proj = [x_proj x_proj_' num2str(kk) '];']);
end;


%Save camera parameters:
fc_save  = fc;
cc_save = cc;
kc_save = kc;

omc_1_save = omc_1;
Rc_1_save = Rc_1;
Tc_1_save = Tc_1;


% Get started to calibrate projector:
clear fc cc kc

n_ima = 1;
X_1 = X_proj;
x_1 = x_proj;


% Image size: (may or may not be available)

nx = 800;
ny = 600;

% No calibration image is available (only the corner coordinates)

no_image = 1;

% Set the toolbox not to prompt the user (choose default values)

dont_ask = 1;

% Do not estimate distortion:

est_dist = [0;0;0;0];
est_dist = ones(4,1);

center_optim = 1;

% Run the main calibration routine:

go_calib_optim_iter;

% Shows the extrinsic parameters:

dX = 3;
dY = 3;

ext_calib;

% Reprojection on the original images:

reproject_calib;




%----------------------- Retrieve results:

% Intrinsic:

% Projector:
fp = fc;
cp = cc;
kp = kc;

% Camera:
fc = fc_save;
cc = cc_save;
kc = kc_save;

% Extrinsic:

% Relative position of projector and camera:
T = Tc_1;
om = omc_1;
R = rodrigues(om);

% Relative prosition of camera wrt world:
omc = omc_1_save;
Rc = Rc_1_save;
Tc = Tc_1_save;

% relative position of projector wrt world:
Rp = R*Rc;
omp = rodrigues(Rp);
Tp = T + R*Tc;
   
eval(['save calib_cam_proj  R om T fc fp cc cp kc kp Rc Rp Tc Tp']);
