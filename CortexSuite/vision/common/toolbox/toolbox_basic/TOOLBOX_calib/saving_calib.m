
if ~exist('n_ima')|~exist('fc'),
   fprintf(1,'No calibration data available.\n');
   return;
end;

check_active_images;

if ~exist('solution_init'), solution_init = []; end;

for kk = 1:n_ima,
   if ~exist(['dX_' num2str(kk)]), eval(['dX_' num2str(kk) '= dX;']); end;
   if ~exist(['dY_' num2str(kk)]), eval(['dY_' num2str(kk) '= dY;']); end;
end;

if ~exist('param_list'),
   param_list = solution;
end;

if ~exist('wintx'),
   wintx = [];
   winty = [];
end;

if ~exist('dX_default'),
   dX_default = [];
   dY_default = [];
end;

if ~exist('alpha_c'),
   alpha_c = 0;
end;

for kk = 1:n_ima,
   if ~exist(['y_' num2str(kk)]),
   	eval(['y_' num2str(kk) ' = NaN*ones(2,1);']);
   end;
   if ~exist(['n_sq_x_' num2str(kk)]),
   	eval(['n_sq_x_' num2str(kk) ' = NaN;']);
   	eval(['n_sq_y_' num2str(kk) ' = NaN;']);
   end; 
   if ~exist(['wintx_' num2str(kk)]),
   	eval(['wintx_' num2str(kk) ' = NaN;']);
   	eval(['winty_' num2str(kk) ' = NaN;']);
   end; 
end;

save_name = 'Calib_Results';

if exist([ save_name '.mat'])==2,
   disp('WARNING: File Calib_Results.mat already exists');
   pfn = -1;
   cont = 1;
   while cont,
      pfn = pfn + 1;
   	postfix = ['_old'num2str(pfn)];
      save_name = [ 'Calib_Results' postfix];
      cont = (exist([ save_name '.mat'])==2);
   end;
   copyfile('Calib_Results.mat',[save_name '.mat']);
	disp(['Copying the current Calib_Results.mat file to ' save_name '.mat']);
end;


save_name = 'Calib_Results';

if exist('calib_name'),
   
   fprintf(1,['\nSaving calibration results under ' save_name '.mat\n']);

   string_save = ['save ' save_name ' center_optim param_list active_images ind_active center_optim est_alpha est_dist fc kc cc alpha_c ex x y solution solution_init wintx winty n_ima type_numbering N_slots small_calib_image first_num image_numbers format_image calib_name Hcal Wcal nx ny map dX_default dY_default KK inv_KK dX dY'];
   
   for kk = 1:n_ima,
   	string_save = [string_save ' X_' num2str(kk) ' x_' num2str(kk) ' y_' num2str(kk) ' ex_' num2str(kk) ' omc_' num2str(kk) ' Rc_' num2str(kk) ' Tc_' num2str(kk) ' H_' num2str(kk) ' n_sq_x_' num2str(kk) ' n_sq_y_' num2str(kk) ' wintx_' num2str(kk) ' winty_' num2str(kk) ' dX_' num2str(kk) ' dY_' num2str(kk)];
   end;
   
else
   
   fprintf(1,['\nSaving calibration results under ' save_name '.mat (no image version)\n']);

   string_save = ['save ' save_name ' center_optim param_list active_images ind_active center_optim est_alpha est_dist fc kc cc alpha_c ex x y solution solution_init wintx winty n_ima nx ny dX_default dY_default KK inv_KK dX dY'];
   
   for kk = 1:n_ima,
   	string_save = [string_save ' X_' num2str(kk) ' x_' num2str(kk) ' y_' num2str(kk) ' ex_' num2str(kk) ' omc_' num2str(kk) ' Rc_' num2str(kk) ' Tc_' num2str(kk) ' H_' num2str(kk) ' n_sq_x_' num2str(kk) ' n_sq_y_' num2str(kk) ' wintx_' num2str(kk) ' winty_' num2str(kk) ' dX_' num2str(kk) ' dY_' num2str(kk)];
   end;
   
end;

   

%fprintf(1,'To load later click on Load\n');

eval(string_save);

fprintf(1,'done\n');