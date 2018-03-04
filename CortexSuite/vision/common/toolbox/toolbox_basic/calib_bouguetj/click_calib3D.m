
if ~exist('I_1'),
   ima_read_calib;
   if no_image_file,
      disp('Cannot extract corners without images');
      return;
   end;
end;

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


disp('WARNNG!!! Do not forget to change dX_default and dY_default in click_calib.m!!!')


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
   click_ima_calib3D; %Simple version
   %init_calib; %advanced vesion (more messy)
end;



string_save = 'save calib_data wintx winty n_ima type_numbering N_slots first_num image_numbers format_image calib_name Hcal Wcal nx ny map dX_default dY_default dX dY';

for kk = 1:n_ima,
   string_save = [string_save ' X_' num2str(kk) ' x_' num2str(kk) ' Hl_' num2str(kk) ' nl_sq_x_' num2str(kk) ' nl_sq_y_' num2str(kk) ' Hr_' num2str(kk) ' nr_sq_x_' num2str(kk) ' nr_sq_y_' num2str(kk)];
end;

eval(string_save);

go_calib_optim3D;
