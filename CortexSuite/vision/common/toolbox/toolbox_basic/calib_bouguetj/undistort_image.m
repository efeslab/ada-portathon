%%% INPUT THE IMAGE FILE NAME:

dir;

fprintf(1,'\n');
disp('Program that undistort an image');
disp('The intrinsic camera parameters are assumed to be known (previously computed)');

fprintf(1,'\n');
image_name = input('Image name (full name without extension): ','s');

format_image2 = '0';

while format_image2 == '0',
   
   format_image2 =  input('Image format: ([]=''r''=''ras'', ''b''=''bmp'', ''t''=''tif'', ''p''=''pgm'', ''j''=''jpg'') ','s');

	if isempty(format_image2),
   	format_image2 = 'ras';
	end;

	if lower(format_image2(1)) == 'b',
   	format_image2 = 'bmp';
	else
   	if lower(format_image2(1)) == 't',
      	format_image2 = 'tif';
   	else
      	if lower(format_image2(1)) == 'p',
         	format_image2 = 'pgm';
	      else
   	      if lower(format_image2(1)) == 'j',
      	      format_image2 = 'jpg';
         	else
            	if lower(format_image2(1)) == 'r',
	              	format_image2 = 'ras';
               else
             		disp('Invalid image format');       
      	         format_image2 = '0'; % Ask for format once again
         	   end;
      	   end;
	      end;
   	end;
	end;
end;

ima_name = [image_name '.' format_image];



%%% READ IN IMAGE:

if format_image(1) == 'p',
   I = double(pgmread(ima_name));
else
   if format_image(1) == 'r',
      I = readras(ima_name);
   else
      I = double(imread(ima_name));
   end;
end;
     
if size(I,3)>1,
   I = I(:,:,2);
end;
   
   
%% SHOW THE ORIGINAL IMAGE:

figure(2);
image(I);
colormap(gray(256));
title('Original image (with distortion) - Stored in array I');
drawnow;


%% UNDISTORT THE IMAGE:

fprintf(1,'Compututing the undistorted image...\n')

[I2] = rect(I,eye(3),fc,cc,kc,KK);


figure(3);
image(I2);
colormap(gray(256));
title('Undistorted image - Stored in array I2');
drawnow;

