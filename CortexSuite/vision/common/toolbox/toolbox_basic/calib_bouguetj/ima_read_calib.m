
if ~exist('calib_name'),
   data_calib;
end;

check_active_images;

images_read = active_images;

image_numbers = first_num:n_ima-1+first_num;

no_image_file = 0;

i = 1;

while (i <= n_ima), % & (~no_image_file),
   
   if active_images(i),
   
   	%fprintf(1,'Loading image %d...\n',i);
   
   	if ~type_numbering,   
      	number_ext =  num2str(image_numbers(i));
   	else
      	number_ext = sprintf(['%.' num2str(N_slots) 'd'],image_numbers(i));
   	end;
   	
      ima_name = [calib_name  number_ext '.' format_image]
      
      if i == ind_active(1),
         fprintf(1,'Loading image ');
      end;
      
      if exist(ima_name),
         
         fprintf(1,'%d...',i);
      	
      	if format_image(1) == 'p',
         	Ii = double(pgmread(ima_name));
      	else
      		if format_image(1) == 'r',
         		Ii = readras(ima_name);
   			else
      			Ii = double(imread(ima_name));
   			end;
      	end;
      	
   		if size(Ii,3)>1,
      		Ii = Ii(:,:,2);
   		end;
   
   		eval(['I_' num2str(i) ' = Ii;']);
         
      else
         
         fprintf(1,'%d...',i);

			images_read(i) = 0;

			no_image_file = 1;
         
		end;
      
   end;
   
   i = i+1;   
   
end;


if no_image_file,
   
   fprintf(1,'\nWARNING! Cannot load calibration images\n');
   
else
   
   fprintf(1,'\n');

   if size(I_1,1)~=480,
   	small_calib_image = 1;
	else
   	small_calib_image = 0;
	end;
   
   [Hcal,Wcal] = size(I_1); 	% size of the calibration image
   
   [ny,nx] = size(I_1);
   
   clickname = [];
   
   map = gray(256);
   
	%string_save = 'save calib_data n_ima type_numbering N_slots image_numbers format_image calib_name Hcal Wcal nx ny map small_calib_image';

	%eval(string_save);

	disp('done');
	%click_calib;

end;

if ~exist('map'), map = gray(256); end;





