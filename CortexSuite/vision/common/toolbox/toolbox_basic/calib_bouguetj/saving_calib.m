fprintf(1,'\nSaving calibration results under Calib_Results.mat\n');

check_active_images;

if ~exist('solution_init'), solution_init = []; end;

for kk = 1:n_ima,
   if ~exist(['dX_' num2str(kk)]), eval(['dX_' num2str(kk) '= dX;']); end;
   if ~exist(['dY_' num2str(kk)]), eval(['dY_' num2str(kk) '= dY;']); end;
end;

if ~exist('param_list'),
   param_list = solution;
end;


string_save = 'save Calib_Results param_list active_images ind_active fc kc cc ex x y solution sol_with_center solution_init wintx winty n_ima type_numbering N_slots small_calib_image first_num image_numbers format_image calib_name Hcal Wcal nx ny map dX_default dY_default KK inv_KK dX dY';

for kk = 1:n_ima,
   string_save = [string_save ' X_' num2str(kk) ' x_' num2str(kk) ' y_' num2str(kk) ' ex_' num2str(kk) ' omc_' num2str(kk) ' Rc_' num2str(kk) ' Tc_' num2str(kk) ' H_' num2str(kk) ' n_sq_x_' num2str(kk) ' n_sq_y_' num2str(kk) ' wintx_' num2str(kk) ' winty_' num2str(kk) ' dX_' num2str(kk) ' dY_' num2str(kk)];
end;

%fprintf(1,'To load later click on Load\n');

fprintf(1,'done\n');

eval(string_save);
