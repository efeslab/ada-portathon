function image = read_image8u_bmp(pathName)

		fid = fopen (pathName,'r'); %FILE *input;
% 		//check for the input FILE pointer
		if(fid == 0)
		
		disp('File pointer error');
        
		else
% 			start of header information
            BYTES_PER_PIXEL=3;
            signature = fread(fid,2,'char=>char');
			file_size = fread(fid,1,'int=>int');
            reserved1 = fread(fid,1,'short=>short');
            reserved2 = fread(fid,1,'short=>short');
			loc_of_bitmap = fread(fid, 1, 'int=>double');
		    size_of_infoheader = fread(fid,1,'int=>int');
            width = fread(fid,1,'int=>double');
            height = fread(fid,1,'int=>double');
            number_of_planes = fread(fid,1,'short=>short');
            bits_per_pixel = fread(fid,1,'short=>short');
            compression_method = fread(fid,1,'int=>int');
            bytes_of_bitmap = fread(fid,1,'int=>int');
            hori_reso = fread(fid,1,'int=>int');    
            vert_reso = fread(fid,1,'int=>int');    			
            no_of_colors = fread(fid,1,'int=>int');    			
            no_of_imp_colors = fread(fid,1,'int=>int');    			
			
			nRows = height;
			nCols = width;			
			nPitch = nCols;
            pad = 4 - (nCols*BYTES_PER_PIXEL - 4*floor(nCols*BYTES_PER_PIXEL/4)); %bitmap multiple-of-4 requirement
			
			pixSize=nRows *nCols * 3;
			
			% Conditions to check whether the BMP is interleaved and handling few exceptions
			if  (nRows <= 0 || nCols <= 0 || signature(1) ~= 'B' || signature(2) ~= 'M'  || bits_per_pixel ~=24)
				disp ('Error');
                return;
            else
        
%read image
%             fseek(fid,loc_of_bitmap,'bof');

			for nI = nRows:-1:1
				for nJ=1:nCols
				
				  image(nI,nJ,3) = fread(fid,1,'char=>uint8'); %B
				  image(nI,nJ,2) = fread(fid,1,'char=>uint8'); %G
  				  image(nI,nJ,1) = fread(fid,1,'char=>uint8'); %R
                  
                end
                if pad~=4
                    for i=1:pad
                    fread(fid,1);               
                    end
                end
            end
            imshow(image);
            imwrite(image,'image.bmp');
			fclose(fid);	

            end
            
        end
        