if ~exist('instructions'), instructions = 1; end;

if instructions,
   
fprintf(1,'\n');
fprintf(1,'*----------------------------------------------------------------------------------------------------*\n');
fprintf(1,'|                         Main Calibration toolbox (2D and 3D rigs)                                  |\n');
fprintf(1,'|                        (c) Jean-Yves Bouguet - September 9th, 1999                                 |\n');
fprintf(1,'*----------------------------------------------------------------------------------------------------*\n\n\n');

fprintf(1,'CLICK ON:\n\n');

fprintf(1,'2D:   To perform camera calibration from multiple views of a 2D planar grid. \n');
fprintf(1,'      Set default size of grid (in dX_default and dY_default) in click_calib.m.\n');
fprintf(1,'3D:   To perform camera calibration from multiple views of a 3D grid corner. \n');
fprintf(1,'      Set default size of grids (in dX_default and dY_default) in click_calib3D.m.\n');
fprintf(1,'Exit: To close the calibration tool. \n');

end;

instructions = 0;

fig_number = 1;

n_row = 1;
n_col = 3;

string_list = cell(n_row,n_col);
callback_list = cell(n_row,n_col);

x_size = 40;
y_size = 20;

title_figure = 'Calibration tool';

string_list{1,1} = '2D rig';
string_list{1,2} = '3D rig';
string_list{1,3} = 'Exit';

callback_list{1,1} = 'calib_gui;';
callback_list{1,2} = 'calib3D_gui;';
callback_list{1,3} = ['disp(''Bye. To run again, type calib.''); close(' num2str(fig_number) ');'];


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

