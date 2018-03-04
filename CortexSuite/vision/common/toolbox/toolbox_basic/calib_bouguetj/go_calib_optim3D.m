% Simplified version of go_calib.m


if ~exist('x_1'),
   click_calib;
end;


fprintf(1,'\nMain calibration procedure\n');

% initial guess for principal point and distortion:
c_init = [nx;ny]/2 - 0.5; % initialize at the center of the image
k_init = [0;0;0;0]; % initialize to zero (no distortion)


% Compute explicitely the focal lentgh using all the (mutually orthogonal) vanishing points
% note: The vanihing points are hidden in the planar collineations H_kk

A = [];
b = [];

% matrix that subtract the principal point:
Sub_cc = [1 0 -c_init(1);0 1 -c_init(2);0 0 1];


for kk=1:n_ima,
   
   % left Pattern:
   
   eval(['Hlkk = Hl_' num2str(kk) ';']);
   
   Hlkk = Sub_cc * Hlkk;

   % Extract vanishing points (direct and diagonals):
   
   Vl_hori_pix = Hlkk(:,1);
   Vl_vert_pix = Hlkk(:,2);
   Vl_diag1_pix = (Hlkk(:,1)+Hlkk(:,2))/2;
   Vl_diag2_pix = (Hlkk(:,1)-Hlkk(:,2))/2;
   
   Vl_hori_pix = Vl_hori_pix/norm(Vl_hori_pix);
   Vl_vert_pix = Vl_vert_pix/norm(Vl_vert_pix);
   Vl_diag1_pix = Vl_diag1_pix/norm(Vl_diag1_pix);
   Vl_diag2_pix = Vl_diag2_pix/norm(Vl_diag2_pix);
   
   al1 = Vl_hori_pix(1);
   bl1 = Vl_hori_pix(2);
   cl1 = Vl_hori_pix(3);
   
   al2 = Vl_vert_pix(1);
   bl2 = Vl_vert_pix(2);
   cl2 = Vl_vert_pix(3);
   
   al3 = Vl_diag1_pix(1);
   bl3 = Vl_diag1_pix(2);
   cl3 = Vl_diag1_pix(3);
   
   al4 = Vl_diag2_pix(1);
   bl4 = Vl_diag2_pix(2);
   cl4 = Vl_diag2_pix(3);
   
   % right Pattern:
   
   eval(['Hrkk = Hr_' num2str(kk) ';']);
   
   Hrkk = Sub_cc * Hrkk;

   % Extract vanishing points (direct and diagonals):
   
   Vr_hori_pix = Hrkk(:,1);
   Vr_vert_pix = Hrkk(:,2);
   Vr_diag1_pix = (Hrkk(:,1)+Hrkk(:,2))/2;
   Vr_diag2_pix = (Hrkk(:,1)-Hrkk(:,2))/2;
   
   Vr_hori_pix = Vr_hori_pix/norm(Vl_hori_pix);
   Vr_vert_pix = Vr_vert_pix/norm(Vl_vert_pix);
   Vr_diag1_pix = Vr_diag1_pix/norm(Vr_diag1_pix);
   Vr_diag2_pix = Vr_diag2_pix/norm(Vr_diag2_pix);
   
   ar1 = Vr_hori_pix(1);
   br1 = Vr_hori_pix(2);
   cr1 = Vr_hori_pix(3);
   
   ar2 = Vr_vert_pix(1);
   br2 = Vr_vert_pix(2);
   cr2 = Vr_vert_pix(3);
   
   ar3 = Vr_diag1_pix(1);
   br3 = Vr_diag1_pix(2);
   cr3 = Vr_diag1_pix(3);
   
   ar4 = Vr_diag2_pix(1);
   br4 = Vr_diag2_pix(2);
   cr4 = Vr_diag2_pix(3);
   
   
   % Collect all the constraints:
   
   A_kk = [al1*al2  bl1*bl2;
      al3*al4  bl3*bl4;
      ar1*ar2  br1*br2;
      ar3*ar4  br3*br4;
      al1*ar1  bl1*br1];
   
   b_kk = -[cl1*cl2;cl3*cl4;cr1*cr2;cr3*cr4;cl1*cr1];
   

   A = [A;A_kk];
   b = [b;b_kk];
   
end;

% use all the vanishing points to estimate focal length:

f_init = sqrt(abs(1./(inv(A'*A)*A'*b))); % if using a two-focal model for initial guess

%f_init = sqrt(b'*(sum(A')') / (b'*b)) * ones(2,1); % if single focal length model is used


% Global calibration matrix (initial guess):
   	
KK = [f_init(1) 0 c_init(1);0 f_init(2) c_init(2); 0 0 1];
inv_KK = inv(KK);

	
% Computing of the extrinsic parameters (from the collineations)

for kk = 1:n_ima,
   
   eval(['Hlkk = Hl_' num2str(kk) ';']);
   
   Hl2 = inv_KK*Hlkk;
      
   sc = mean([norm(Hl2(:,1));norm(Hl2(:,2))]);
   
 	Hl2 = Hl2/sc;
    
   eval(['Hrkk = Hr_' num2str(kk) ';']);
   
   Hr2 = inv_KK*Hrkk;
      
   sc = mean([norm(Hr2(:,1));norm(Hr2(:,2))]);
   
   Hr2 = Hr2/sc;
   
   omcl = rodrigues([Hl2(:,1:2) cross(Hl2(:,1),Hl2(:,2))]);
   Tcl = Hl2(:,3);
   
   %omcr = rodrigues([Hr2(:,1:2) cross(Hr2(:,1),Hr2(:,2))]);
   %Tcr = Hr2(:,3);
   
   
  	omckk = omcl; %rodrigues([H2(:,1:2) cross(H2(:,1),H2(:,2))]);
  	Tckk = Tcl; %H2(:,3);
   
  	eval(['omc_' num2str(kk) ' = omckk;']);
  	eval(['Tc_' num2str(kk) ' = Tckk;']);
   	
end;


      
% Initialisation of the parameters for global minimization:

init_param = [f_init;k_init];

for kk = 1:n_ima,   
   eval(['init_param = [init_param; omc_' num2str(kk) '; Tc_' num2str(kk) '];']);
end;

if ~exist('lsqnonlin'),

	options = [1 1e-4 1e-4 1e-6  0 0 0 0 0 0 0 0 0 6000 0 1e-8 0.1 0];

	if exist('leastsq'),
   	sss = ['[param,opt] = leastsq(''multi_error_oulu'',init_param,options,[],n_ima,c_init);'];
	else
   	sss = ['[param,opt] = leastsq2(''multi_error_oulu'',init_param,options,[],n_ima,c_init);'];
	end;

else
   
   options = optimset('lsqnonlin');
   options.MaxIter  = 6000;
   options.Display = 'iter';
  	sss = ['[param,opt] = lsqnonlin(''multi_error_oulu'',init_param,[],[],options,n_ima,c_init);'];

end;


fprintf(1,'\nOptimization not including the principal point...\n')
eval(sss);

history  = [[init_param;c_init] [param;c_init]];

sol_no_center = [param;c_init];

init_param = sol_no_center;

fprintf(1,'\nOptimization including the principal point...\n')

eval(sss);

history = [history param];


sol_with_center = param;




%%% Extraction of the final intrinsic and extrinsic paramaters (in the no-center case):

solution = sol_no_center;
extract_parameters3D;

fprintf(1,'\n\nCalibration results without principal point estimation:\n\n');
fprintf(1,'Focal Length:     fc = [ %3.5f   %3.5f]\n',fc);
fprintf(1,'Principal point:  cc = [ %3.5f   %3.5f]\n',cc);
fprintf(1,'Distortion:       kc = [ %3.5f   %3.5f   %3.5f   %3.5f]\n',kc);   
fprintf(1,['Pixel error:      [click on ''sol. without center'']\n']); 




% Pick the solution with principal point
%%% NOTE: At that point, the user can choose which solution to pick: with or without
%%% principal point estimation. By default, we pick the solution with principal point.

solution = sol_with_center;



%%% Extraction of the final intrinsic and extrinsic paramaters:

extract_parameters3D;


fprintf(1,'\n\nCalibration results with principal point estimation:\n\n');
fprintf(1,'Focal Length:     fc = [ %3.5f   %3.5f]\n',fc);
fprintf(1,'Principal point:  cc = [ %3.5f   %3.5f]\n',cc);
fprintf(1,'Distortion:       kc = [ %3.5f   %3.5f   %3.5f   %3.5f]\n',kc);   


%%%%%%%%%%%%%%%%%%%% GRAPHICAL OUTPUT %%%%%%%%%%%%%%%%%%%%%%%%

graphout_calib3D;



fprintf(1,'Note: If the solution is not satisfactory, select solution without center estimation.\n\n');


%%%%%%%%%%%%%% Save all the Calibration results:

disp('Save calibration results under Calib_Results.mat');

string_save = 'save Calib_Results fc kc cc ex x y solution sol_with_center sol_no_center history wintx winty n_ima type_numbering N_slots small_calib_image first_num image_numbers format_image calib_name Hcal Wcal nx ny map dX_default dY_default KK inv_KK dX dY';

for kk = 1:n_ima,
   string_save = [string_save ' X_' num2str(kk) ' x_' num2str(kk) ' y_' num2str(kk) ' ex_' num2str(kk) ' omc_' num2str(kk) ' Tc_' num2str(kk) ' Hl_' num2str(kk) ' nl_sq_x_' num2str(kk) ' nl_sq_y_' num2str(kk) ' Hr_' num2str(kk) ' nr_sq_x_' num2str(kk) ' nr_sq_y_' num2str(kk)];
end;

eval(string_save);
