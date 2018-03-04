if ~exist('instructions3D'), instructions3D = 1; end;

if instructions3D,
   
fprintf(1,'\n');
fprintf(1,'*----------------------------------------------------------------------------------------------------*\n');
fprintf(1,'|           Canera calibration from multiple images of the Intel 3D calibration rig                  |\n');
fprintf(1,'|                         (c) Jean-Yves Bouguet - September 2nd, 1999                                |\n');
fprintf(1,'*----------------------------------------------------------------------------------------------------*\n\n\n');

fprintf(1,'LIST OF CALIBRATION COMMANDS (to be executed from 1 to 5):\n\n');

fprintf(1,'1- Image names:          Lets the user enter the file names of the calibration images (max = 30 images).\n');
fprintf(1,'                         It includes basename, image type (''tif'', ''bmp'' or ''ras''), numbering scheme.\n');
fprintf(1,'                         Automatically launchs the next step (Read images).\n');
fprintf(1,'2- Read images:          Reads in the calibration images from files.\n');
fprintf(1,'                         Does not automatically launch the next step (Extract grid corners).\n');
fprintf(1,'3- Extract grid corners: Extracts the grid corners from the image.\n');
fprintf(1,'                         Based six maual clicks per image.\n');
fprintf(1,'                         The calibration data is saved under ''calib_data.mat''.\n');
fprintf(1,'                         Automatically launchs the next step (Run calibration).\n');
fprintf(1,'4- Run calibration:      Main calibration procedure.\n');
fprintf(1,'                         Optimization of intrinsic and extrinsic parameters to minimize\n');
fprintf(1,'                         the reprojection error (in the least squares sense.\n');
fprintf(1,'                         Estimated parameters: 2 focal lengths, principal point,\n');
fprintf(1,'                         radial (2 coeff. -> 4 degree model) and tangential (2 coeff.) distortion,\n');
fprintf(1,'                         and extrinsic parameters (6 parameters per image).\n');
fprintf(1,'                         The final solution is saved under ''Calib_Results.mat''.\n');
fprintf(1,'                         For a description of the intrinsic camera model, refer to the reference:\n');
fprintf(1,'                         "A Four-step Camera Calibration Procedure with implicit Image Correction"\n');
fprintf(1,'                         Janne Heikkila and Olli Silven, Infotech Oulu and Department of EE\n');
fprintf(1,'                         University of Oulu, Appeared in CVPR''97, Puerto Rico.\n');
fprintf(1,'                         Visit http://www.ee.oulu.fi/~jth/calibr/Calibration.html\n');
fprintf(1,'                         Automatically launchs the next step (Graphic out).\n');
fprintf(1,'5- Graphic out:          Generates the graphical output associated to the current calibration solution.\n');
fprintf(1,'                         It shows the 3D locations of the grids, and reprojects the 3D patterns on the\n');
fprintf(1,'                         original calibration images.\n');
fprintf(1,'6- sol. with center:     Lets the user select the calibration solution with computed principal point.\n');
fprintf(1,'                         This is the default case (solution retained after Run calibration).\n');
fprintf(1,'                         Automatically (re)generates the graphical output associated to that solution.\n');
fprintf(1,'7- sol. without center:  Lets the users select the calibration solution without computed principal point.\n');
fprintf(1,'                         In that case, the principal point is assumed at the center of the image.\n');
fprintf(1,'                         Automatically generates the graphical output associated to that solution.\n');
fprintf(1,'                         This option is sometimes useful when the principal point is difficult to\n');
fprintf(1,'                         estimate (in particular when the camera field of view is small).\n');
fprintf(1,'8- Back to main:         Goes back to the main calbration toolbox window.\n\n\n');

end;

instructions3D = 0;

global X_1 x_1 X_2 x_2 X_3 x_3 X_4 x_4 X_5 x_5 X_6 x_6 X_7 x_7 X_8 x_8 X_9 x_9 X_10 x_10 X_11 x_11 X_12 x_12 X_13 x_13 X_14 x_14 X_15 x_15 X_16 x_16 X_17 x_17 X_18 x_18 X_19 x_19 X_20 x_20 X_21 x_21 X_22 x_22 X_23 x_23 X_24 x_24 X_25 x_25 X_26 x_26 X_27 x_27 X_28 x_28 X_29 x_29 X_30 x_30 


fig_number = 1;

n_row = 2;
n_col = 4;

string_list = cell(n_row,n_col);
callback_list = cell(n_row,n_col);

x_size = 85;
y_size = 20;

title_figure = 'Camera calibration tool (3D rig)';

string_list{1,1} = 'Image names';
string_list{1,2} = 'Read images';
string_list{1,3} = 'Extract grid corners';
string_list{1,4} = 'Run calibration';
string_list{2,1} = 'Graphic out';
string_list{2,2} = 'sol. with center';
string_list{2,3} = 'sol. without center';
string_list{2,4} = 'Back to main';

callback_list{1,1} = 'data_calib;';
callback_list{1,2} = 'ima_read_calib;';
callback_list{1,3} = 'click_calib3D;';
callback_list{1,4} = 'go_calib_optim3D;';
callback_list{2,1} = 'graphout_calib3D;';
callback_list{2,2} = 'select_sol_with_center3D;';
callback_list{2,3} = 'select_sol_no_center3D;';
callback_list{2,4} = 'calib;';


figure(fig_number); clf;
pos = get(fig_number,'Position');

fig_size_x = x_size*n_col+(n_col+1)*2;
fig_size_y = y_size*n_row+(n_row+1)*2;

set(fig_number,'Units','points', ...
	'BackingStore','off', ...
	'Color',[0.8 0.8 0.8], ...
	'MenuBar','none', ...
	'Resize','off', ...
	'Name',title_figure, ...
'Position',[pos(1) pos(2) fig_size_x fig_size_y], ...
'NumberTitle','off');


for i=n_row:-1:1,
   for j = n_col:-1:1,
      if (~isempty(callback_list{i,j}))&(~isempty(string_list{i,j})),
      	uicontrol('Parent',fig_number, ...
         	'Units','points', ...
			'Callback',callback_list{i,j}, ...
			'ListboxTop',0, ...
			'Position',[(2+(j-1)*(x_size+2))   (fig_size_y - i*(2+y_size))  x_size   y_size], ...
			'String',string_list{i,j}, ...
         'Tag','Pushbutton1');
      end;
	end;
end;
