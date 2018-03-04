%init_calib_param
%
%Initialization of the intrinsic and extrinsic parameters.
%Runs as a script.
%
%This function is obsolete with init_intrinsic_param called from go_calib_optim
%
%INPUT: x_1,x_2,x_3,...: Feature locations on the images
%       X_1,X_2,X_3,...: Corresponding grid coordinates
%
%OUTPUT: fc: Camera focal length
%        cc: Principal point coordinates
%	      kc: Distortion coefficients
%        KK: The camera matrix (containing fc and cc)
%        omc_1,omc_2,omc_3,...: 3D rotation vectors attached to the grid positions in space
%        Tc_1,Tc_2,Tc_3,...: 3D translation vectors attached to the grid positions in space
%        Rc_1,Rc_2,Rc_3,...: 3D rotation matrices corresponding to the omc vectors
%
%Method: Compute the planar homographies H_1, H_2, H_3, ... and computes
%        the focal length fc from orthogonal vanishing points constraint.
%        The principal point cc is assumed at the center of the image.
%        Assumes no image distortion (kc = [0;0;0;0])
%        Once the intrinsic parameters are estimated, the extrinsic parameters
%        are computed for each image.
%
%Note: The row vector active_images consists of zeros and ones. To deactivate an image, set the
%      corresponding entry in the active_images vector to zero.
%
%
%Important functions called within that program:
%
%compute_homography.m: Computes the planar homography between points on the grid in 3D, and the image plane.
%
%compute_extrinsic.m: Computes the location of a grid assuming known intrinsic parameters.
%                      This function is called at the initialization step.




check_active_images;

if ~exist(['x_' num2str(ind_active(1)) ]),
   click_calib;
end;


fprintf(1,'\nInitialization of the calibration parameters - Number of images: %d\n',length(ind_active));


% Initialize the homographies:

for kk = 1:n_ima,
   eval(['x_kk = x_' num2str(kk) ';']);
   eval(['X_kk = X_' num2str(kk) ';']);
   if (isnan(x_kk(1,1))),
      if active_images(kk),
         fprintf(1,'WARNING: Cannot calibrate with image %d. Need to extract grid corners first.\n',kk)
         fprintf(1,'         Set active_images(%d)=1; and run Extract grid corners.\n',kk)
      end;
      active_images(kk) = 0;
   end;
   if active_images(kk),
      eval(['H_' num2str(kk) ' = compute_homography(x_kk,X_kk(1:2,:));']);
   else
      eval(['H_' num2str(kk) ' = NaN*ones(3,3);']);
   end;
end;

check_active_images;

% initial guess for principal point and distortion:

if ~exist('nx'), [ny,nx] = size(I); end;

c_init = [nx;ny]/2 - 0.5; % initialize at the center of the image
k_init = [0;0;0;0]; % initialize to zero (no distortion)



% Compute explicitely the focal length using all the (mutually orthogonal) vanishing points
% note: The vanihing points are hidden in the planar collineations H_kk

A = [];
b = [];

% matrix that subtract the principal point:
Sub_cc = [1 0 -c_init(1);0 1 -c_init(2);0 0 1];

for kk=1:n_ima,
   
   if active_images(kk),
      
   	eval(['Hkk = H_' num2str(kk) ';']);
   
   	Hkk = Sub_cc * Hkk;   
   
   	% Extract vanishing points (direct and diagonals):
   
   	V_hori_pix = Hkk(:,1);
   	V_vert_pix = Hkk(:,2);
   	V_diag1_pix = (Hkk(:,1)+Hkk(:,2))/2;
   	V_diag2_pix = (Hkk(:,1)-Hkk(:,2))/2;
   
   	V_hori_pix = V_hori_pix/norm(V_hori_pix);
   	V_vert_pix = V_vert_pix/norm(V_vert_pix);
   	V_diag1_pix = V_diag1_pix/norm(V_diag1_pix);
   	V_diag2_pix = V_diag2_pix/norm(V_diag2_pix);
      
      a1 = V_hori_pix(1);
      b1 = V_hori_pix(2);
      c1 = V_hori_pix(3);
      
   	a2 = V_vert_pix(1);
   	b2 = V_vert_pix(2);
   	c2 = V_vert_pix(3);
   	
   	a3 = V_diag1_pix(1);
   	b3 = V_diag1_pix(2);
   	c3 = V_diag1_pix(3);
   	
   	a4 = V_diag2_pix(1);
   	b4 = V_diag2_pix(2);
   	c4 = V_diag2_pix(3);
 	
 	   A_kk = [a1*a2  b1*b2;
	    	    a3*a4  b3*b4];
   
   	b_kk = -[c1*c2;c3*c4];
   	
		
   	A = [A;A_kk];
   	b = [b;b_kk];
      
   end;
   
end;


% use all the vanishing points to estimate focal length:

f_init = sqrt(abs(1./(inv(A'*A)*A'*b))); % if using a two-focal model for initial guess

%f_init = sqrt(b'*(sum(A')') / (b'*b)) * ones(2,1); % if single focal length model is used


% Global calibration matrix (initial guess):
   	
KK = [f_init(1) 0 c_init(1);0 f_init(2) c_init(2); 0 0 1];
inv_KK = inv(KK);


cc = c_init;
fc = f_init;
kc = k_init;


% Computing of the extrinsic parameters (from the collineations)

for kk = 1:n_ima,
   
   if active_images(kk),
      
      
   	eval(['x_kk = x_' num2str(kk) ';']);
      eval(['X_kk = X_' num2str(kk) ';']);
      
      [omckk,Tckk] = compute_extrinsic(x_kk,X_kk,fc,cc,kc);
      
      Rckk = rodrigues(omc_kk);
         
   else
      
      omckk = NaN*ones(3,1);
      Tckk = NaN*ones(3,1);
      Rckk = NaN*ones(3,3);
      
	end;

   eval(['omc_' num2str(kk) ' = omckk;']);
   eval(['Rc_' num2str(kk) ' = Rckk;']);
   eval(['Tc_' num2str(kk) ' = Tckk;']);
      
end;


% Initialization of the parameters for global minimization:

init_param = [f_init;k_init];

for kk = 1:n_ima,   
   eval(['init_param = [init_param; omc_' num2str(kk) '; Tc_' num2str(kk) '];']);
end;

solution_init = [init_param;c_init];

solution = solution_init;

comp_error_calib;

fprintf(1,'\n\nCalibration parameters after initialization:\n\n');
fprintf(1,'Focal Length:     fc = [ %3.5f   %3.5f]\n',fc);
fprintf(1,'Principal point:  cc = [ %3.5f   %3.5f]\n',cc);
fprintf(1,'Distortion:       kc = [ %3.5f   %3.5f   %3.5f   %3.5f]\n',kc);   
fprintf(1,'Pixel error:      err = [ %3.5f   %3.5f]\n\n',err_std); 


%%%%%%%%%%%%%%%%%%%% GRAPHICAL OUTPUT %%%%%%%%%%%%%%%%%%%%%%%%

%graphout_calib;

