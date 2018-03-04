
if ~exist('I_1'),
   ima_read_calib;
   if no_image_file,
      disp('Cannot extract corners without images');
      return;
   end;
end;

check_active_images;

%wintx = 10; % neigborhood of integration for
%winty = 10; % the corner finder

fprintf(1,'\nExtraction of the grid corners on the images\n');

disp('Window size for corner finder (wintx and winty):');
wintx = input('wintx ([] = 5) = ');
if isempty(wintx), wintx = 5; end;
wintx = round(wintx);
winty = input('winty ([] = 5) = ');
if isempty(winty), winty = 5; end;
winty = round(winty);

fprintf(1,'Window size = %dx%d\n',2*wintx+1,2*winty+1);

if ~exist('map'), map = gray(256); end;


disp('WARNING!!! Do not forget to change dX_default and dY_default in click_calib.m!!!')


% Default size of the pattern squares;

% Setup of JY (old at Caltech)
dX_default = 21.9250/11;
dY_default = 18.1250/9;

% Setup of JY (new at Intel)
dX_default = 1.9750;
dY_default = 1.9865;


% Setup of Luis and Enrico
dX_default = 67.7/16;
dY_default = 50.65/12;


% Setup of German
dX_default = 10.16;
dY_default = 10.16;

% Setup of JY (new at Intel)
dX_default = 1.9750*2.54;
dY_default = 1.9865*2.54;

% Setup of JY - 3D calibration rig at Intel (new at Intel)
dX_default = 3;
dY_default = 3;

% Useful option to add images:
kk_first = input('Start image number ([]=1=first): ');

if isempty(kk_first), kk_first = 1; end;

for kk = kk_first:n_ima,
   if active_images(kk),
      click_ima_calib;
   else
	   eval(['dX_' num2str(kk) ' = NaN;']);
   	eval(['dY_' num2str(kk) ' = NaN;']);  
   
   	eval(['wintx_' num2str(kk) ' = NaN;']);
   	eval(['winty_' num2str(kk) ' = NaN;']);

   	eval(['x_' num2str(kk) ' = NaN*ones(2,1);']);
   	eval(['X_' num2str(kk) ' = NaN*ones(3,1);']);
   
   	eval(['n_sq_x_' num2str(kk) ' = NaN;']);
   	eval(['n_sq_y_' num2str(kk) ' = NaN;']);
   end;
end;



string_save = 'save calib_data active_images ind_active wintx winty n_ima type_numbering N_slots first_num image_numbers format_image calib_name Hcal Wcal nx ny map dX_default dY_default dX dY';

for kk = 1:n_ima,
   string_save = [string_save ' X_' num2str(kk) ' x_' num2str(kk) ' n_sq_x_' num2str(kk) ' n_sq_y_' num2str(kk) ' wintx_' num2str(kk) ' winty_' num2str(kk) ' dX_' num2str(kk) ' dY_' num2str(kk)];
end;

eval(string_save);

disp('done');

return;

go_calib_optim;

