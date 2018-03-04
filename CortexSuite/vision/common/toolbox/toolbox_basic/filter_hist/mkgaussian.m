function G = mkgaussian(xo,yo,sigma_x,sigma_y,size_w)
%  
%   function G = mkgaussian(xo,yo,sigma_x,sigma_y,size_w)
%
 
size_wh = round(0.5*size_w);

[x,y] = meshgrid([-size_wh:1:size_wh],[-size_wh:1:size_wh]);

G = 0.5/(sigma_x*sigma_y)*(exp(-( ((x-xo)/sigma_x).^2 + ((y-yo)/sigma).^2)));

