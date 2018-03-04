fig_number = 1;

n_row = 5;
n_col = 4;

string_list = cell(n_row,n_col);
callback_list = cell(n_row,n_col);

x_size = 85;
y_size = 20;

title_figure = 'Camera calibration tool (2D rig)';

string_list{1,1} = 'Image names';
string_list{1,2} = 'Read images';
string_list{1,3} = 'Extract grid corners';
%string_list{1,4} = 'Initialization';
string_list{1,4} = 'Calibration';
string_list{2,1} = 'Show Extrinsic';
string_list{2,2} = 'Reproject on images';
string_list{2,3} = 'Analyse error';
string_list{2,4} = 'Recomp. corners';
string_list{3,1} = 'Add/Suppress images';
string_list{3,2} = 'Save';
string_list{3,3} = 'Load';
string_list{3,4} = 'Exit';

string_list{5,1} = 'Comp. Extrinsic';
string_list{5,2} = 'Undistort image';


callback_list{1,1} = 'data_calib;';
callback_list{1,2} = 'ima_read_calib;';
callback_list{1,3} = 'click_calib;';
%callback_list{1,4} = 'init_calib_param;';
callback_list{1,4} = 'go_calib_optim;';
callback_list{2,1} = 'ext_calib;';
callback_list{2,2} = 'reproject_calib;';
callback_list{2,3} = 'analyse_error;';
callback_list{2,4} = 'recomp_corner_calib;';
callback_list{3,1} = 'add_suppress;';
callback_list{3,2} = 'saving_calib;';
callback_list{3,3} = 'loading_calib;';
callback_list{3,4} = ['disp(''Bye. To run again, type calib_gui.''); close(' num2str(fig_number) ');'];

callback_list{5,1} = 'extrinsic_computation;';
callback_list{5,2} = 'undistort_image;';


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
'NumberTitle','off'); %,'WindowButtonMotionFcn',['figure(' num2str(fig_number) ');']);


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


clear callback_list string_list fig_number fig_size_x fig_size_y i j n_col n_row pos string_list title_figure x_size y_size
