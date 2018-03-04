function [x,y,z] = hsv2clrs(h,s,v)
%
%  function [x,y,z] = hsv2clrs(h,s,v)
%     if h is 3D matrix, output in 3D x
%

if (size(h,3) == 3),
  s = h(:,:,2);
  v = h(:,:,3);
  h = h(:,:,1);

  z = v;
  xx = s.*v.*cos(2*pi*h);
  y = s.*v.*sin(2*pi*h);

  x(:,:,1) = xx;
  x(:,:,2) = y;
  x(:,:,3) = z;
else
  
  z = v;
  x = s.*v.*cos(2*pi*h);
  y = s.*v.*sin(2*pi*h);
end

