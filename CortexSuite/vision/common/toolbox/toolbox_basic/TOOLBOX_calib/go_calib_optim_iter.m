%go_calib_optim_iter
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
%For now, if using a 3D calibration rig, quick_init is set to 1 for an easy initialization of the focal length


if ~exist('center_optim'),
	center_optim = 1; %%% Set this variable to 0 if your do not want to estimate the principal point
end;

if ~exist('est_dist'),
   est_dist = [1;1;1;1];
end;

if ~exist('est_alpha'),
   est_alpha = 0; % by default, do not estimate skew
end;


% Little fix in case of stupid values in the binary variables:
center_optim = ~~center_optim;
est_alpha = ~~est_alpha;
est_dist = ~~est_dist;


if ~exist('nx')&~exist('ny'),
   fprintf(1,'WARNING: No image size (nx,ny) available. Setting nx=640 and ny=480\n');
   nx = 640;
   ny = 480;
end;


check_active_images;


quick_init = 0; % Set to 1 for using a quick init (necessary when using 3D rigs)


if ~center_optim, % In the case where the principal point is not estimated, keep it at the center of the image
   fprintf(1,'Principal point not optimized (center_optim=0). It is kept at the center of the image.\n');
   cc = [(nx-1)/2;(ny-1)/2];
end;


if ~prod(est_dist),
   fprintf(1,'\nDistortion not fully estimated. Check variable est_dist.\n');
end;

if ~est_alpha,
   fprintf(1,'Skew not optimized (est_alpha=0).\n');
   alpha_c = 0;
end;


% Check 3D-ness of the calibration rig:
rig3D = 0;
for kk = ind_active,
   eval(['X_kk = X_' num2str(kk) ';']);
   if is3D(X_kk),
      rig3D = 1;
   end;
end;

% If the rig is 3D, then no choice: the only valid initialization is manual!
if rig3D,
   quick_init = 1;
end;



alpha_smooth = 1; % set alpha_smooth = 1; for steepest gradient descent


% Conditioning threshold for view rejection
thresh_cond = 1e6;



%% Initialization of the intrinsic parameters (if necessary)

if ~exist('cc'),
   fprintf(1,'Initialization of the principal point at the center of the image.\n');
   cc = [(nx-1)/2;(ny-1)/2];
   alpha_smooth = 0.4; % slow convergence
end;


if ~exist('kc'),
   fprintf(1,'Initialization of the image distortion to zero.\n');
   kc = zeros(4,1);
   alpha_smooth = 0.4; % slow convergence
end;

if ~exist('alpha_c'),
   fprintf(1,'Initialization of the image skew to zero.\n');
   alpha_c = 0;
   alpha_smooth = 0.4; % slow convergence
end;

if ~exist('fc')& quick_init,
   FOV_angle = 35; % Initial camera field of view in degrees
   fprintf(1,['Initialization of the focal length to a FOV of ' num2str(FOV_angle) ' degrees.\n']);
   fc = (nx/2)/tan(pi*FOV_angle/360) * ones(2,1);
   alpha_smooth = 0.4; % slow 
end;


if ~exist('fc'),
   % Initialization of the intrinsic parameters:
   fprintf(1,'Initialization of the intrinsic parameters using the vanishing points of planar patterns.\n')
   init_intrinsic_param; % The right way to go (if quick_init is not active)!
   alpha_smooth = 0.4; % slow convergence
end;


if ~prod(est_dist),
   % If no distortion estimated, set to zero the variables that are not estimated
   kc = kc .* est_dist;
end;





%% Initialization of the extrinsic parameters for global minimization:


init_param = [fc;cc;alpha_c;kc;zeros(6,1)]; 



for kk = 1:n_ima,

	if exist(['x_' num2str(kk)]),
   
   	eval(['x_kk = x_' num2str(kk) ';']);
      eval(['X_kk = X_' num2str(kk) ';']);
      
   	if (isnan(x_kk(1,1))),
      	if active_images(kk),
         	fprintf(1,'Warning: Cannot calibrate with image %d. Need to extract grid corners first.\n',kk)
         	fprintf(1,'         Set active_images(%d)=1; and run Extract grid corners.\n',kk)
      	end;
      	active_images(kk) = 0;
      end;
      if active_images(kk),
         [omckk,Tckk] = compute_extrinsic_init(x_kk,X_kk,fc,cc,kc,alpha_c);
         [omckk,Tckk,Rckk,JJ_kk] = compute_extrinsic_refine(omckk,Tckk,x_kk,X_kk,fc,cc,kc,alpha_c,20,thresh_cond);
         if cond(JJ_kk)> thresh_cond,
            active_images(kk) = 0;
            omckk = NaN*ones(3,1);
            Tckk = NaN*ones(3,1);
            fprintf(1,'\nWarning: View #%d ill-conditioned. This image is now set inactive.\n',kk)
            desactivated_images = [desactivated_images kk];
         end;
         if isnan(omckk(1,1)),
            %fprintf(1,'\nWarning: Desactivating image %d. Re-activate it later by typing:\nactive_images(%d)=1;\nand re-run optimization\n',[kk kk])
            active_images(kk) = 0;
         end;
      else
         omckk = NaN*ones(3,1);
         Tckk = NaN*ones(3,1);
      end;
   
   else
      
      omckk = NaN*ones(3,1);
      Tckk = NaN*ones(3,1);
      
      if active_images(kk),
         fprintf(1,'Warning: Cannot calibrate with image %d. Need to extract grid corners first.\n',kk)
         fprintf(1,'         Set active_images(%d)=1; and run Extract grid corners.\n',kk)
      end;
      
      active_images(kk) = 0;
      
   end;
   
   eval(['omc_' num2str(kk) ' = omckk;']);
   eval(['Tc_' num2str(kk) ' = Tckk;']);
   
   init_param = [init_param; omckk ; Tckk];
   
end;


check_active_images;



%-------------------- Main Optimization:

fprintf(1,'\nMain calibration optimization procedure - Number of images: %d\n',length(ind_active));


param = init_param;
change = 1;

iter = 0;

fprintf(1,'Gradient descent iterations: ');

param_list = param;

MaxIter = 30;


while (change > 1e-6)&(iter < MaxIter),
   
   fprintf(1,'%d...',iter+1);
   
   
   %% The first step consists of updating the whole vector of knowns (intrinsic + extrinsic of active
   %% images) through a one step steepest gradient descent.
   
	JJ = [];
	ex = [];
	   
   f = param(1:2);
   c = param(3:4);
   alpha = param(5);
   k = param(6:9);

   
   for kk = 1:n_ima,
      
      if active_images(kk),
  	 
   		%omckk = param(4+6*(kk-1) + 3:6*kk + 3); 
   	
         %Tckk = param(6*kk+1 + 3:6*kk+3 + 3);  
         
         omckk = param(15+6*(kk-1) + 1:15+6*(kk-1) + 3); 
   	
         Tckk = param(15+6*(kk-1) + 4:15+6*(kk-1) + 6); 
         
         if isnan(omckk(1)),
            fprintf(1,'Intrinsic parameters at frame %d do not exist\n',kk);
            return;
         end;
         
   		eval(['X_kk = X_' num2str(kk) ';']);
   		eval(['x_kk = x_' num2str(kk) ';']);
   	
   		Np = size(X_kk,2);
   	
   		JJkk = zeros(2*Np,n_ima * 6 + 15);
   	
   		[x,dxdom,dxdT,dxdf,dxdc,dxdk,dxdalpha] = project_points2(X_kk,omckk,Tckk,f,c,k,alpha);
      
   		exkk = x_kk - x;
   
   		ex = [ex;exkk(:)];
         
         JJkk(:,1:2) = dxdf;
    		JJkk(:,3:4) = dxdc;
         JJkk(:,5) = dxdalpha;
         JJkk(:,6:9) = dxdk;
   		JJkk(:,15+6*(kk-1) + 1:15+6*(kk-1) + 3) = dxdom;
   		JJkk(:,15+6*(kk-1) + 4:15+6*(kk-1) + 6) = dxdT;

         
         
         JJ = [JJ;JJkk];
         
         
         % Check if this view is ill-conditioned:
         JJ_kk = [dxdom dxdT];
         if cond(JJ_kk)> thresh_cond,
            active_images(kk) = 0;
            fprintf(1,'\nWarning: View #%d ill-conditioned. This image is now set inactive.\n',kk)
            desactivated_images = [desactivated_images kk];
            param(15+6*(kk-1) + 1:15+6*(kk-1) + 6) = NaN*ones(6,1); 
         end;
            
         
      end;
   	
   end;
   
   
   % List of active images (necessary if changed):
   check_active_images;
   
   
   % The following vector helps to select the variables to update (for only active images):
   
   ind_Jac = find([ones(2,1);center_optim*ones(2,1);est_alpha;est_dist;zeros(6,1);reshape(ones(6,1)*active_images,6*n_ima,1)])';

   
   JJ = JJ(:,ind_Jac);
   
   JJ2 = JJ'*JJ;
   
   
   % Smoothing coefficient:
   
   alpha_smooth2 = 1-(1-alpha_smooth)^(iter+1); %set to 1 to undo any smoothing!
   
   
   param_innov = alpha_smooth2*inv(JJ2)*(JJ')*ex;
   param_up = param(ind_Jac) + param_innov;
   param(ind_Jac) = param_up;
   
   
   % New intrinsic parameters:
   
   fc_current = param(1:2);
   cc_current = param(3:4);
   alpha_current = param(5);
   kc_current = param(6:9);

   
   % Change on the intrinsic parameters:
   change = norm([fc_current;cc_current] - [f;c])/norm([fc_current;cc_current]);
   
   
   %% Second step: (optional) - It makes convergence faster, and the region of convergence LARGER!!!
   %% Recompute the extrinsic parameters only using compute_extrinsic.m (this may be useful sometimes)
   %% The complete gradient descent method is useful to precisely update the intrinsic parameters.
      
   MaxIter2 = 20;
   
   
   for kk = 1:n_ima,
      if active_images(kk),
         omc_current = param(15+6*(kk-1) + 1:15+6*(kk-1) + 3);
         Tc_current = param(15+6*(kk-1) + 4:15+6*(kk-1) + 6);
      	eval(['X_kk = X_' num2str(kk) ';']);
         eval(['x_kk = x_' num2str(kk) ';']);
         [omc_current,Tc_current] = compute_extrinsic_init(x_kk,X_kk,fc_current,cc_current,kc_current,alpha_current);
         [omckk,Tckk,Rckk,JJ_kk] = compute_extrinsic_refine(omc_current,Tc_current,x_kk,X_kk,fc_current,cc_current,kc_current,alpha_current,MaxIter2,thresh_cond);
         if cond(JJ_kk)> thresh_cond,
            active_images(kk) = 0;
            fprintf(1,'\nWarning: View #%d ill-conditioned. This image is now set inactive.\n',kk)
            desactivated_images = [desactivated_images kk];
            omckk = NaN*ones(3,1);
            Tckk = NaN*ones(3,1);
         end;
         param(15+6*(kk-1) + 1:15+6*(kk-1) + 3) = omckk;
         param(15+6*(kk-1) + 4:15+6*(kk-1) + 6) = Tckk;
      end;
   end;
   
   param_list = [param_list param];
   
   iter = iter + 1;
   
end;

fprintf(1,'\n');


solution = param;


%%% Extraction of the final intrinsic and extrinsic paramaters:

extract_parameters;

comp_error_calib;

fprintf(1,'\n\nCalibration results after optimization:\n\n');
fprintf(1,'Focal Length:          fc = [ %3.5f   %3.5f ]\n',fc);
fprintf(1,'Principal point:       cc = [ %3.5f   %3.5f ]\n',cc);
fprintf(1,'Skew:             alpha_c = [ %3.5f ]   => angle of pixel = %3.5f degrees\n',alpha_c,90 - atan(alpha_c)*180/pi);
fprintf(1,'Distortion:            kc = [ %3.5f   %3.5f   %3.5f   %3.5f ]\n',kc);   
fprintf(1,'Pixel error:          err = [ %3.5f   %3.5f ]\n\n',err_std); 

