%%%%%%%%%%%%%%%%%%%% REPROJECT ON THE IMAGES %%%%%%%%%%%%%%%%%%%%%%%%

if ~exist('no_image'),
   no_image = 0;
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
   	ima_read_calib;
   	if no_image_file,
      	fprintf(1,'WARNING: Do not show the original images\n'); %return;
   	end;
   end;
else
   no_image_file = 1;
end;



ima_numbers = input('Number(s) of image(s) to show ([] = all images) = ');

if isempty(ima_numbers),
   ima_proc = 1:n_ima;
else
   ima_proc = ima_numbers;
end;


figure(5);
for kk = ima_proc, %1:n_ima,
   if active_images(kk) & eval(['~isnan(y_' num2str(kk) '(1,1))']),
	   eval(['plot(ex_' num2str(kk) '(1,:),ex_' num2str(kk) '(2,:),''' colors(rem(kk-1,6)+1) '+'');']);
      hold on;
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
   	hold off;
   	drawnow;

      set(5+kk,'Name',num2str(kk),'NumberTitle','off');
      
   end;
   
end;


err_std = std(ex')';

fprintf(1,'Pixel error:      err = [ %3.5f   %3.5f]\n\n',err_std); 
