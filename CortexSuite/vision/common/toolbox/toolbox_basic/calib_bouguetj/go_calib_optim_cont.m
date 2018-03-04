% Simplified version of go_calib.m

if ~exist('x_1'),
   click_calib;
end;
      

% Initialisation of the parameters for global minimization:

init_param = [fc;kc];

for kk = 1:n_ima,
   
   if ~exist(['omc_' num2str(kk)]),
      eval(['Hkk = H_' num2str(kk) ';']);
   	H2 = inv_KK*Hkk;
      sc = mean([norm(H2(:,1));norm(H2(:,2))]);
   	H2 = H2/sc;
      omckk = rodrigues([H2(:,1:2) cross(H2(:,1),H2(:,2))]);
      Tckk = H2(:,3);
      eval(['omc_' num2str(kk) ' = omckk;']);
      eval(['Tc_' num2str(kk) ' = Tckk;']);
   end;
   
   eval(['init_param = [init_param; omc_' num2str(kk) '; Tc_' num2str(kk) '];']);
end;

init_param = [init_param;cc];



%-------------------- Main Optimization:

fprintf(1,'\nRe-Optimization...\n')


param = init_param;
change = 1;

iter = 0;

fprintf(1,'Iteration ');

while (change > 1e-6)&(iter < 10),
   
   fprintf(1,'%d...',iter+1);

	JJ = [];
	ex = [];
	
	c = param(6*n_ima + 4 + 3:6*n_ima + 5 + 3);
	f = param(1:2);
	k = param(3:6);
	
	for kk = 1:n_ima,
  	 
   	omckk = param(4+6*(kk-1) + 3:6*kk + 3);
   	
  		Tckk = param(6*kk+1 + 3:6*kk+3 + 3);
   	
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
   	
	end;
	
	param_innov = inv(JJ'*JJ)*(JJ')*ex;
	param_up = param + param_innov;
	change = norm(param_innov)/norm(param_up);
	param = param_up;
	iter = iter + 1;
   
end;

fprintf(1,'\n');


sol_with_center = param;

solution = sol_with_center;


%%% Extraction of the final intrinsic and extrinsic paramaters:

extract_parameters;
comp_error_calib;

fprintf(1,'\n\nCalibration results with principal point estimation:\n\n');
fprintf(1,'Focal Length:     fc = [ %3.5f   %3.5f]\n',fc);
fprintf(1,'Principal point:  cc = [ %3.5f   %3.5f]\n',cc);
fprintf(1,'Distortion:       kc = [ %3.5f   %3.5f   %3.5f   %3.5f]\n',kc);   
fprintf(1,'Pixel error:      err = [ %3.5f   %3.5f]\n\n',err_std); 


%%%%%%%%%%%%%%%%%%%% GRAPHICAL OUTPUT %%%%%%%%%%%%%%%%%%%%%%%%

graphout_calib;



fprintf(1,'Note: If the solution is not satisfactory, select solution without center estimation.\n\n');


%%%%%%%%%%%%%% Save all the Calibration results:

disp('Save calibration results under Calib_Results.mat');

string_save = 'save Calib_Results fc kc cc ex x y solution sol_with_center solution_init history wintx winty n_ima type_numbering N_slots small_calib_image first_num image_numbers format_image calib_name Hcal Wcal nx ny map dX_default dY_default KK inv_KK dX dY';

for kk = 1:n_ima,
   string_save = [string_save ' X_' num2str(kk) ' x_' num2str(kk) ' y_' num2str(kk) ' ex_' num2str(kk) ' omc_' num2str(kk) ' Rc_' num2str(kk) ' Tc_' num2str(kk) ' H_' num2str(kk) ' Hini_' num2str(kk) ' n_sq_x_' num2str(kk) ' n_sq_y_' num2str(kk) ' wintx_' num2str(kk) ' winty_' num2str(kk) ' dX_' num2str(kk) ' dY_' num2str(kk)];
end;

eval(string_save);

return;

if exist('calib_data.mat'),
   ccc = computer;
   if ccc(1)=='P',
      eval('!del calib_data.mat');
   else
      eval('!rm calib_data.mat');
   end;
end;
