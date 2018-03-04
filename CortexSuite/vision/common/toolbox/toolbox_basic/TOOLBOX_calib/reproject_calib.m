%%%%%%%%%%%%%%%%%%%% REPROJECT ON THE IMAGES %%%%%%%%%%%%%%%%%%%%%%%%

if ~exist('n_ima')|~exist('fc'),
   fprintf(1,'No calibration data available.\n');
   return;
end;

if ~exist('no_image'),
   no_image = 0;
end;

if ~exist('nx')&~exist('ny'),
   fprintf(1,'WARNING: No image size (nx,ny) available. Setting nx=640 and ny=480\n');
   nx = 640;
   ny = 480;
end;


check_active_images;


% Color code for each image:

colors = 'brgkcm';

% Reproject the patterns on the images, and compute the pixel errors:

% Reload the images if necessary

if ~exist(['omc_' num2str(ind_active(1)) ]),
   fprintf(1,'Need to calibrate before showing image reprojection. Maybe need to load Calib_Results.mat file.\n');
   return;
end;

if ~no_image,
	if ~exist(['I_' num2str(ind_active(1)) ]'),
	   n_ima_save = n_ima;
	   active_images_save = active_images;
	   ima_read_calib;
	   n_ima = n_ima_save;
	   active_images = active_images_save;
	   check_active_images;
   	if no_image_file,
	   fprintf(1,'WARNING: Do not show the original images\n'); %return;
   	end;
   end;
else
   no_image_file = 1;
end;


if ~exist('dont_ask'),
   dont_ask = 0;
end;


if ~dont_ask,
   ima_numbers = input('Number(s) of image(s) to show ([] = all images) = ');
else
   ima_numbers = [];
end;


if isempty(ima_numbers),
   ima_proc = 1:n_ima;
else
   ima_proc = ima_numbers;
end;


figure(5);
for kk = ima_proc, %1:n_ima,
   if exist(['y_' num2str(kk)]),
   if active_images(kk) & eval(['~isnan(y_' num2str(kk) '(1,1))']),
	   eval(['plot(ex_' num2str(kk) '(1,:),ex_' num2str(kk) '(2,:),''' colors(rem(kk-1,6)+1) '+'');']);
      hold on;
   end;
   end;
end;
hold off;
axis('equal');
title('Reprojection error (in pixel)');
xlabel('x');
ylabel('y');
drawnow;

set(5,'Name','error','NumberTitle','off');



for kk = ima_proc,
   if exist(['y_' num2str(kk)]),
   if active_images(kk) & eval(['~isnan(y_' num2str(kk) '(1,1))']),
   
   	if exist(['I_' num2str(kk)]),
	   eval(['I = I_' num2str(kk) ';']);
   	else
	   I = 255*ones(ny,nx);
   	end;
   
   	figure(5+kk);
   	image(I); hold on;
   	colormap(gray(256));
   	title(['Image ' num2str(kk) ' - Image points (+) and reprojected grid points (o)']);
   	eval(['plot(x_' num2str(kk) '(1,:)+1,x_' num2str(kk) '(2,:)+1,''r+'');']);
   	eval(['plot(y_' num2str(kk) '(1,:)+1,y_' num2str(kk) '(2,:)+1,''' colors(rem(kk-1,6)+1) 'o'');']);
      zoom on;
      axis([1 nx 1 ny]);
   	hold off;
   	drawnow;

      set(5+kk,'Name',num2str(kk),'NumberTitle','off');
      
   end;
   end;
end;


err_std = std(ex')';

fprintf(1,'Pixel error:      err = [%3.5f   %3.5f] (all active images)\n\n',err_std); 
