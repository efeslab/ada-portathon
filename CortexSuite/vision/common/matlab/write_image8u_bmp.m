function image = write_image8u_bmp(inpImage, pathName) % this is matlab's sequence, removed width, height since they can be inferred from image

BYTES_PER_PIXEL = 3;

fid = fopen (pathName,'w'); %FILE *input;
% 		//check for the input FILE pointer
if(fid == 0)		
    disp('File pointer error');
else
    height = size(inpImage,1);
    width=size(inpImage,2);
    signature(1) = 'B';
    signature(2) = 'M';
    
    reserved1 = 0;
    reserved2 = 0;
    file_size = (height*width*BYTES_PER_PIXEL)+54;
    offset=54;
	size_of_infoheader=40;
	number_of_planes=1;
	bits_per_pixel= 8*BYTES_PER_PIXEL ;
	compression_method=0;
	hori_reso=2835;
	vert_reso=2835;
	no_of_colors=0;
	no_of_imp_colors=0;
	
% 	start of header information
    fwrite(fid,signature(1),'char');  
    fwrite(fid,signature(2),'char');  
    fwrite(fid,file_size,'int');
    fwrite(fid,reserved1,'short');
    fwrite(fid,reserved2,'short');
    fwrite(fid,offset,'int');
    fwrite(fid,size_of_infoheader,'int');
    fwrite(fid,width,'int');
    fwrite(fid,height,'int');
    fwrite(fid,number_of_planes,'short');
    fwrite(fid,bits_per_pixel,'short');
    fwrite(fid,compression_method,'int');
    
    bytes_of_bitmap=width*height*BYTES_PER_PIXEL;
    
    fwrite(fid,bytes_of_bitmap,'int');
    fwrite(fid,hori_reso,'int');    
    fwrite(fid,vert_reso,'int');    			
    fwrite(fid,no_of_colors,'int');    			
    fwrite(fid,no_of_imp_colors,'int');    			

	% Conditions to check whether the BMP is gray scaled and handling few exceptions

    if (width <= 0 || height <= 0 || signature(1) ~= 'B' || signature(2) ~= 'M')
        return;
    end
			
	% total size of pixels
	% pixSize=srcImage->height * srcImage->width * NO_OF_BYTE_PER_PIXEL; //*3 is done as it is a 3 channel image
    %reverse the image back

    for nI=1:height
        count = 0;
        for nJ=1:width
          temp = inpImage((height - nI+1),nJ,3);
          fwrite(fid,temp,'char');
          temp = inpImage((height - nI+1),nJ,2);
          fwrite(fid,temp,'char');
          temp = inpImage((height - nI+1),nJ,1);
          fwrite(fid,temp,'char');
          
        end
       pad = 4 - (width*BYTES_PER_PIXEL - (4*floor(width*BYTES_PER_PIXEL/4))); %bitmap multiple-of-4 requirement
       if pad ~= 0
           temp=0;
           for cnt = 1:pad
              fwrite(fid,temp,'char');
%               fwrite(fid,temp,'char');
%               fwrite(fid,temp,'char');              
           end
       end
    end
    
    outImage = imread(pathName);
    imshow(outImage);
    fclose(fid);	
    
end
            
        