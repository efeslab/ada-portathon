function srcImage = readImage(pathName)

    %Reading BMP image 
    input = fopen(pathName,'r');
    %start of header information
    signature = fread(input, 2, 'uchar');
    file_size = fread(input, 1, 'uint32');          
    reserved1 = fread(input, 1, 'uint16');
    reserved2 = fread(input, 1, 'uint16');
    loc_of_bitmap = fread(input, 1, 'uint32');

    size_of_infoheader = fread(input, 1, 'uint32');
    width = fread(input, 1, 'uint32');
    height = fread(input, 1, 'uint32');
    number_of_planes = fread(input, 1, 'uint16');
    bits_per_pixel = fread(input, 1, 'uint16');
    compression_method = fread(input, 1, 'uint32');
    bytes_of_bitmap = fread(input, 1, 'uint32');

    hori_reso = fread(input, 1, 'uint32');
    vert_reso = fread(input, 1, 'uint32');
    no_of_colors = fread(input, 1, 'uint32');
    no_of_imp_colors = fread(input, 1, 'uint32');        

    %end of header information

    srcImage = zeros(height, width);

    % Conditions to check whether the BMP is interleaved and handling few exceptions
    if (height <= 0 || width <= 0 || signature(1) ~= 'B' || signature(2) ~= 'M'  || ( bits_per_pixel ==16))
        disp('Error in file format');
        srcImage = 0;
    end

    status = fseek(input,loc_of_bitmap,-1);

    nI = 0;
    nJ = 0;
    
    if(bits_per_pixel == 24)
    for nI=height:-1:1
        for nJ=1:width
            tempb = fread(input, 1,'uchar');
            tempg = fread(input, 1,'uchar');
            tempr = fread(input, 1,'uchar');
            srcImage(nI,nJ) = uint8((tempb + 6*tempg + 3*tempr)/10);
            srcImage(nI,nJ) = uint8(tempg);
        end
    end
    else 
    for nI=height:-1:1
        for nJ=1:width
            tempg = fread(input, 1,'uchar');
            srcImage(nI,nJ) = tempg;
        end
    end
    end
    
    fclose(input);
end
