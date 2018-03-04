   check_active_images;


fprintf(1,'\nThis function is useful to select a subset of images to calibrate\n');

   fprintf(1,'\nThere are currently %d active images selected for calibration (out of %d):\n',length(ind_active),n_ima);
   
   if ~isempty(ind_active),
   
   	for ii = 1:length(ind_active)-2,
      	
         fprintf(1,'%d, ',ind_active(ii));
         
      end;
      
      fprintf(1,'%d and %d.',ind_active(end-1),ind_active(end));

   end;
   
   fprintf(1,'\n');
   
   
fprintf(1,'\nDo you want to suppress or add images from that list?\n');

choice = 2;

while (choice~=0)&(choice~=1),
   choice = input('For suppressing images enter 0, for adding images enter 1 ([]=no change): ');
   if isempty(choice),
      fprintf(1,'No change applied to the list of active images.\n');
      return;
   end;
   if (choice~=0)&(choice~=1),
      disp('Bad entry. Try again.');
   end;
end;


if choice,
   
	ima_numbers = input('Number(s) of image(s) to add ([] = all images) = ');

if isempty(ima_numbers),
	   fprintf(1,'All %d images are now active\n',n_ima);
   	ima_proc = 1:n_ima;
	else
   	ima_proc = ima_numbers;
	end;
   
else
   
   
	ima_numbers = input('Number(s) of image(s) to suppress ([] = no image) = ');

	if isempty(ima_numbers),
      fprintf(1,'No image has been suppressed. No modication of the list of active images.\n',n_ima);
   	ima_proc = [];
	else
   	ima_proc = ima_numbers;
	end;
   
end;

if ~isempty(ima_proc),
   
   active_images(ima_proc) = choice * ones(1,length(ima_proc));
   
end;


   check_active_images;
   

   fprintf(1,'\nThere is now a total of %d active images for calibration:\n',length(ind_active));
   
   if ~isempty(ind_active),
   
   	for ii = 1:length(ind_active)-2,
      	
         fprintf(1,'%d, ',ind_active(ii));
         
      end;
      
      fprintf(1,'%d and %d.',ind_active(end-1),ind_active(end));

   end;
   
   fprintf(1,'\n\nYou may now run ''Calibration'' to recalibrate based on this new set of images.\n');
   
   
   