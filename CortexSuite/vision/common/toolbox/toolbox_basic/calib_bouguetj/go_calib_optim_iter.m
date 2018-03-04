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


check_active_images;



quick_init = 0; % Set to 1 for using a quick init (necessary when using 3D rigs)



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




alpha = 0.4; % set alpha = 1; for steepest gradient descent


% Conditioning threshold for view rejection
thresh_cond = 1e6;




%% Initialization of the intrinsic parameters (if necessary)

if ~exist('cc'),
   fprintf(1,'Initialization of the principal point at the center of the image.\n');
   cc = [(nx-1)/2;(ny-1)/2];
end;


if ~exist('kc'),
   fprintf(1,'Initialization of the image distortion to zero.\n');
   kc = zeros(4,1);
end;


if ~exist('fc')& quick_init,
   FOV_angle = 35; % Initial camera field of view in degrees
   fprintf(1,['Initialization of the focal length to a FOV of ' num2str(FOV_angle) ' degrees.\n']);
   fc = (nx/2)/tan(pi*FOV_angle/360) * ones(2,1);
end;


if ~exist('fc'),
   % Initialization of the intrinsic parameters:
   fprintf(1,'Initialization of the intrinsic parameters using the vanishing points of planar patterns.\n')
   init_intrinsic_param; % The right way to go (if quick_init is not active)!
end;



%% Initialization of the extrinsic parameters for global minimization:

init_param = [fc;kc];

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
         [omckk,Tckk] = compute_extrinsic_init(x_kk,X_kk,fc,cc,kc);
         [omckk,Tckk,Rckk,JJ_kk] = compute_extrinsic_refine(omckk,Tckk,x_kk,X_kk,fc,cc,kc,20,thresh_cond);
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
   
   eval(['init_param = [init_param; omc_' num2str(kk) '; Tc_' num2str(kk) '];']);
   
end;


check_active_images;

init_param = [init_param;cc];

%-------------------- Main Optimization:

fprintf(1,'\nMain calibration optimization procedure - Number of images: %d\n',length(ind_active));


% The following vector helps to select the variables to update:
ind_Jac = find([ones(6,1);reshape(ones(6,1)*active_images,6*n_ima,1);ones(2,1)])';

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
	
	c = param(6*n_ima + 4 + 3:6*n_ima + 5 + 3);
	f = param(1:2);
	k = param(3:6);
	
   for kk = 1:n_ima,
      
      if active_images(kk),
  	 
   		omckk = param(4+6*(kk-1) + 3:6*kk + 3);
   	
         Tckk = param(6*kk+1 + 3:6*kk+3 + 3);
         
         if isnan(omckk(1)),
            fprintf(1,'Intrinsic parameters at frame %d do not exist\n',kk);
            return;
         end;
         
   		eval(['X_kk = X_' num2str(kk) ';']);
   		eval(['x_kk = x_' num2str(kk) ';']);
   	
   		Np = size(X_kk,2);
   	
   		JJkk = zeros(2*Np,n_ima * 6 + 8);
   	
   		[x,dxdom,dxdT,dxdf,dxdc,dxdk] = project_points(X_kk,omckk,Tckk,f,c,k);
      
   		exkk = x_kk - x;
   
   		ex = [ex;exkk(:)];
   
   		JJkk(:,1:2) = dxdf;
   		JJkk(:,3:6) = dxdk;
   		JJkk(:,4+6*(kk-1) + 3:6*kk + 3) = dxdom;
   		JJkk(:,6*kk+1 + 3:6*kk+3 + 3) = dxdT;
   		JJkk(:,6*n_ima + 4 + 3:6*n_ima + 5 + 3) = dxdc;
   			
         JJ = [JJ;JJkk];
         
         
         % Check if this view is ill-conditioned:
         JJ_kk = [dxdom dxdT];
         if cond(JJ_kk)> thresh_cond,
            active_images(kk) = 0;
            fprintf(1,'\nWarning: View #%d ill-conditioned. This image is now set inactive.\n',kk)
            desactivated_images = [desactivated_images kk];
            param(4+6*(kk-1) + 3:6*kk+3 + 3) = NaN*ones(6,1);
         end;
            
         
      end;
   	
   end;
   
   
   % List of active images (necessary if changed):
   check_active_images;
   ind_Jac = find([ones(6,1);reshape(ones(6,1)*active_images,6*n_ima,1);ones(2,1)])';
   
   
   JJ = JJ(:,ind_Jac);
   
   JJ2 = JJ'*JJ;
   
   
   % Smoothing coefficient:
   
   alpha2 = 1-(1-alpha)^(iter+1); %set to 1 to undo any smoothing!
   
   
   param_innov = alpha2*inv(JJ2)*(JJ')*ex;
   param_up = param(ind_Jac) + param_innov;
   param(ind_Jac) = param_up;
   
   
   % New intrinsic parameters:
   
   fc_current = param(1:2);
   cc_current = param(6*n_ima + 4 + 3:6*n_ima + 5 + 3);
   kc_current = param(3:6);
   
   
   % Change on the intrinsic parameters:
   change = norm([fc_current;cc_current] - [f;c])/norm([fc_current;cc_current]);
   
   
   %% Second step: (optional) - It makes convergence faster, and the region of convergence LARGER!!!
   %% Recompute the extrinsic parameters only using compute_extrinsic.m (this may be useful sometimes)
   %% The complete gradient descent method is useful to precisely update the intrinsic parameters.
      
   MaxIter2 = 20;
   
   for kk = 1:n_ima,
      if active_images(kk),
         omc_current = param(4+6*(kk-1) + 3:6*kk + 3);
         Tc_current = param(6*kk+1 + 3:6*kk+3 + 3);
      	eval(['X_kk = X_' num2str(kk) ';']);
         eval(['x_kk = x_' num2str(kk) ';']);
         [omc_current,Tc_current] = compute_extrinsic_init(x_kk,X_kk,fc_current,cc_current,kc_current);
         [omckk,Tckk,Rckk,JJ_kk] = compute_extrinsic_refine(omc_current,Tc_current,x_kk,X_kk,fc_current,cc_current,kc_current,MaxIter2,thresh_cond);
         if cond(JJ_kk)> thresh_cond,
            active_images(kk) = 0;
            fprintf(1,'\nWarning: View #%d ill-conditioned. This image is now set inactive.\n',kk)
            desactivated_images = [desactivated_images kk];
            omckk = NaN*ones(3,1);
            Tckk = NaN*ones(3,1);
         end;
			param(4+6*(kk-1) + 3:6*kk + 3) = omckk;
         param(6*kk+1 + 3:6*kk+3 + 3) = Tckk;
      end;
   end;
   
   %fprintf(1,'\n\nCalibration results after optimization:\n\n');
   %fprintf(1,'focal      = [%3.5f   %3.5f]\n',fc_current);
   %fprintf(1,'center     = [%3.5f   %3.5f]\n',cc_current);
   %fprintf(1,'distortion = [%3.5f   %3.5f  %3.5f   %3.5f]\n\n',kc_current);   
   
   
   param_list = [param_list param];
   
   iter = iter + 1;
   
end;

fprintf(1,'\n');


sol_with_center = param;

solution = param;


%%% Extraction of the final intrinsic and extrinsic paramaters:

extract_parameters;
comp_error_calib;

fprintf(1,'\n\nCalibration results after optimization:\n\n');
fprintf(1,'Focal Length:     fc = [ %3.5f   %3.5f]\n',fc);
fprintf(1,'Principal point:  cc = [ %3.5f   %3.5f]\n',cc);
fprintf(1,'Distortion:       kc = [ %3.5f   %3.5f   %3.5f   %3.5f]\n',kc);   
fprintf(1,'Pixel error:      err = [ %3.5f   %3.5f]\n\n',err_std); 

