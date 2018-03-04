function []= ppm2jpg(fname,dlm,ori)
%
%  ppm2jpg(fname,dlm,ori)
%      
%     dlm =1, remove the file extension from fname
%             before convert
%     ori =1, transpose the image
%

if dlm,
 dlm = findstr(fname,'.');
 fname = fname(1:dlm(end)-1);
end

fname_1 = sprintf('%s.ppm',fname);
I = readppm(fname_1);

if ori == 1,
  I = permute(I,[2 1 3]);
end


fname_2 = sprintf('%s.jpg',fname);
imwrite(I,fname_2,'jpeg','Quality',90);

