function Is = read_imgs(homedir,imgdir,prename,postname,digits,startid,endid,step_img)
%
% Is = read_imgs(homedir,imgdir,prename,postname,digits,startid,endid,step_img)
%



command = ['%s%s%s%.',num2str(digits),'d%s'];

fname = sprintf(command,homedir,imgdir,prename,startid,postname);
disp(fname);
if (strcmp('.ppm',postname)),
 I1 = readppm(fname);
else
   I1 = imread(fname); 
end


Is = zeros(size(I1,1),size(I1,2),size(I1,3),1+floor((endid-startid)/step_img));
Is(:,:,:,1) = I1;
im_id = 1;
for j = startid+step_img:step_img:endid,
    command = ['%s%s%s%.',num2str(digits),'d%s'];
    fname = sprintf(command,homedir,imgdir,prename,j,postname);
    disp(fname);
    im_id = im_id+1;
    
    if (strcmp('.ppm',postname)),
      Is(:,:,:,im_id) = readppm(fname);
    else
      a = imread(fname); 
      Is(:,:,:,im_id) = a;
    end
end






