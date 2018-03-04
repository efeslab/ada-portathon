%go_calib_optim
%
%Main calibration function. Computes the intrinsic andextrinsic parameters.
%Runs as a script.
%
%INPUT: x_1,x_2,x_3,...: Feature locations on the images
%       X_1,X_2,X_3,...: Corresponding grid coordinates
%
%OUTPUT: fc: Camera focal length
%        cc: Principal point coordinates
%        kc: Distortion coefficients
%        KK: The camera matrix (containing fc and cc)
%        omc_1,omc_2,omc_3,...: 3D rotation vectors attached to the grid positions in space
%        Tc_1,Tc_2,Tc_3,...: 3D translation vectors attached to the grid positions in space
%        Rc_1,Rc_2,Rc_3,...: 3D rotation matrices corresponding to the omc vectors
%
%Method: Minimizes the pixel reprojection error in the least squares sense over the intrinsic
%        camera parameters, and the extrinsic parameters (3D locations of the grids in space)
%
%Note: If the intrinsic camera parameters (fc, cc, kc) do not exist before, they are initialized through
%      the function init_intrinsic_param.m. Otherwise, the variables in memory are used as initial guesses.
%
%Note: The row vector active_images consists of zeros and ones. To deactivate an image, set the
%      corresponding entry in the active_images vector to zero.
%
%VERY IMPORTANT: This function works for 2D and 3D calibration rigs, except for init_intrinsic_param.m
%that is so far implemented to work only with 2D rigs.
%In the future, a more general function will be there.
%For now, if using a 3D calibration rig, set quick_init to 1 for an easy initialization of the focal length


if ~exist('n_ima'),
   data_calib; % Load the images
   click_calib; % Extract the corners
end;


check_active_images;

check_extracted_images;

check_active_images;
 

desactivated_images = [];


if ~exist('center_optim'),
	center_optim = 1; %%% Set this variable to 0 if your do not want to estimate the principal point
                     %%% Required when using one image, and VERY RECOMMENDED WHEN USING LESS THAN 4 images
end;                  
		  
% Check 3D-ness of the calibration rig:
rig3D = 0;
for kk = ind_active,
   eval(['X_kk = X_' num2str(kk) ';']);
   if is3D(X_kk),
      rig3D = 1;
   end;
end;


if center_optim & (length(ind_active) < 2) & ~rig3D,
   fprintf(1,'\nPrincipal point rejected from the optimization when using one image and planar rig (center_optim = 1).\n');
   center_optim = 0; %%% when using a single image, please, no principal point estimation!!!
   est_alpha = 0;
end;

if ~exist('dont_ask'),
   dont_ask = 0;
end;

if center_optim & (length(ind_active) < 5),
   fprintf(1,'\nThe principal point estimation may be unreliable (using less than 5 images for calibration).\n');
   if ~dont_ask,
      quest = input('Are you sure you want to keep the principal point in the optimization process? ([]=yes, other=no) ');
      center_optim = isempty(quest);
   end;
end;

if center_optim,
   fprintf(1,'\nINFO: To reject the principal point from the optimization, set center_optim = 0 in go_calib_optim.m\n');
end;

if ~exist('est_alpha'),
   est_alpha = 0; % by default, do not estimate skew
end;

if ~center_optim & (est_alpha),
   fprintf(1,'WARNING: Since there is no principal point estimation, no skew estimation (est_alpha = 0)\n');
   est_alpha = 0;
else
	if ~est_alpha,
   	fprintf(1,'WARNING: Skew not optimized. Check variable est_alpha.\n');
   	alpha_c = 0;
	else
   	fprintf(1,'WARNING: Skew is optimized. To disable skew estimation, set est_alpha=0.\n');
	end;   
end;


if ~exist('est_dist');
   est_dist = [1;1;1;1];
end;
if ~prod(est_dist),
   fprintf(1,'\nWARNING: Distortion not fully estimated. Check variable est_dist.\n');
end;




%%% MAIN OPTIMIZATION CALL!!!!! (look into this function for the details of implementation)
go_calib_optim_iter;



if ~isempty(desactivated_images),
   
   param_list_save = param_list;
   
   fprintf(1,'\nNew optimization including the images that have been deactivated during the previous optimization.\n');
   active_images(desactivated_images) = ones(1,length(desactivated_images));
   desactivated_images = [];
   
   go_calib_optim_iter;
   
   if ~isempty(desactivated_images),
      fprintf(1,['List of images left desactivated: ' num2str(desactivated_images) '\n' ] );
   end;
   
   param_list = [param_list_save(:,1:end-1) param_list];
   
end;


%%%%%%%%%%%%%%%%%%%% GRAPHICAL OUTPUT %%%%%%%%%%%%%%%%%%%%%%%%

%graphout_calib;

