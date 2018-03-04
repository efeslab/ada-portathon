%%% This script alets the user enter the name of the images (base name, numbering scheme,...

dir;

%disp('Camera Calibration using multiple images of a planar checkerboard pattern');
%disp('Model: 2 focals, 2 radial dist. coeff., 2 tangential dist. coeff. and principle point');
%disp('       => 8DOF intrinsic model ([Heikkila and Silven, University of Oulu])');

fprintf(1,'\n');
calib_name = input('Basename camera calibration images (without number nor suffix): ','s');

format_image = '0';

while format_image == '0',
   
   format_image =  input('Image format: ([]=''r''=''ras'', ''b''=''bmp'', ''t''=''tif'', ''p''=''pgm'', ''j''=''jpg'') ','s');

	if isempty(format_image),
   	format_image = 'ras';
	end;

	if lower(format_image(1)) == 'b',
   	format_image = 'bmp';
	else
   	if lower(format_image(1)) == 't',
      	format_image = 'tif';
   	else
      	if lower(format_image(1)) == 'p',
         	format_image = 'pgm';
	      else
   	      if lower(format_image(1)) == 'j',
      	      format_image = 'jpg';
         	else
            	if lower(format_image(1)) == 'r',
	              	format_image = 'ras';
               else
             		disp('Invalid image format');       
      	         format_image = '0'; % Ask for format once again
         	   end;
      	   end;
	      end;
   	end;
	end;
   
end;


n_ima = 1000;
while n_ima > 30,
   n_ima = input('Number of calibration images: ');
   n_ima = round(n_ima);
end;

type_numbering = input('Type of numbering (ex: []=4,other=04): ');

type_numbering = ~isempty(type_numbering);

if type_numbering,
   
   N_slots = input('Number of spaces for numbers? (ex: 2 -> 04, 3 -> 004), ([]=3) ');

   if isempty(N_slots), N_slots = 3; end;

else
   
   N_slots = 1; % not used anyway, but useful for saving
   
end;


first_num = input('First image number? (0,1,2...) ([]=0) ');
 
if isempty(first_num), first_num = 0; end;

image_numbers = first_num:n_ima-1+first_num;


%%% By default, all the images are active for calibration:

active_images = ones(1,n_ima);

%string_save = 'save calib_data n_ima type_numbering N_slots image_numbers format_image calib_name first_num';

%eval(string_save);

% Reading images:

ima_read_calib;

