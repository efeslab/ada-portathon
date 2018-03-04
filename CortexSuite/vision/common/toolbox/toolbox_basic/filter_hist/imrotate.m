function bout = imrotate(arg1,arg2,arg3,arg4)
%IMROTATE Rotate image.
%	B = IMROTATE(A,ANGLE,'method') rotates the image A by ANGLE
%	degrees.  The image returned B will, in general, be larger 
%	than A.  Invalid values on the periphery are set to one
%	for indexed images or zero for all other image types. Possible 
%	interpolation methods are 'nearest','bilinear' or 'bicubic'.
%	'bilinear' is the default for intensity images, otherwise 
%	'nearest' is used if no method is given.
%
%	B = IMROTATE(A,ANGLE,'crop') or IMROTATE(A,ANGLE,'method','crop')
%	crops B to be the same size as A.
%
%	Without output arguments, IMROTATE(...) displays the rotated
%	image in the current axis.
%
%	See also IMRESIZE, IMCROP, ROT90.

%	Clay M. Thompson 8-4-92
%	Copyright (c) 1992 by The MathWorks, Inc.
%	$Revision: 1.14 $  $Date: 1993/09/01 21:27:38 $

if nargin<2, error('Requires at least two input parameters.'); end
if nargin<3,
  if isgray(arg1), caseid = 'bil'; else caseid = 'nea'; end
  docrop = 0;
elseif nargin==3,
  if isstr(arg3),
    method = [lower(arg3),'   ']; % Protect against short method
    caseid = method(1:3);
    if caseid(1)=='c', % Crop string
      if isgray(arg1), caseid = 'bil'; else caseid = 'nea'; end
      docrop = 1;
    else
      docrop = 0;
    end
  else
    error('''METHOD'' must be a string of at least three characters.');
  end
else
  if isstr(arg3),
    method = [lower(arg3),'   ']; % Protect against short method
    caseid = method(1:3);
  else
    error('''METHOD'' must be a string of at least three characters.');
  end
  docrop = 1;
end

% Catch and speed up 90 degree rotations
if rem(arg2,90)==0 & nargin<4,
  phi = rem(arg2,360);
  if phi==90,
    b = rot90(arg1);
  elseif phi==180,
    b = rot90(arg1,2);
  elseif phi==270,
    b = rot90(arg1,-1);
  else
    b = arg1;
  end
  if nargout==0, imshow(b), else bout = b; end
  return
end
      
phi = arg2*pi/180; % Convert to radians

% Rotation matrix
T = [cos(phi) -sin(phi); sin(phi) cos(phi)];

% Coordinates from center of A
[m,n] = size(arg1);
if ~docrop, % Determine limits for rotated image
  siz = ceil(max(abs([(n-1)/2 -(m-1)/2;(n-1)/2 (m-1)/2]*T))/2)*2;
  uu = -siz(1):siz(1); vv = -siz(2):siz(2);
else % Cropped image
  uu = (1:n)-(n+1)/2; vv = (1:m)-(m+1)/2;
end
nu = length(uu); nv = length(vv);

blk = bestblk([nv nu]);
nblks = floor([nv nu]./blk); nrem = [nv nu] - nblks.*blk;
mblocks = nblks(1); nblocks = nblks(2);
mb = blk(1); nb = blk(2);

rows = 1:blk(1); b = zeros(nv,nu);
for i=0:mblocks,
  if i==mblocks, rows = (1:nrem(1)); end
  for j=0:nblocks,
    if j==0, cols = 1:blk(2); elseif j==nblocks, cols=(1:nrem(2)); end
    if ~isempty(rows) & ~isempty(cols)
      [u,v] = meshgrid(uu(j*nb+cols),vv(i*mb+rows));
      % Rotate points
      uv = [u(:) v(:)]*T'; % Rotate points
      u(:) = uv(:,1)+(n+1)/2; v(:) = uv(:,2)+(m+1)/2;
      if caseid(1)=='n', % Nearest neighbor interpolation
        b(i*mb+rows,j*nb+cols) = interp6(arg1,u,v);
      elseif all(caseid=='bil'), % Bilinear interpolation
        b(i*mb+rows,j*nb+cols) = interp4(arg1,u,v);
      elseif all(caseid=='bic'), % Bicubic interpolation
        b(i*mb+rows,j*nb+cols) = interp5(arg1,u,v);
      else
        error(['Unknown interpolation method: ',method]);
      end
    end
  end
end

d = find(isnan(b));
if length(d)>0, 
  if isind(arg1), b(d) = ones(size(d)); else b(d) = zeros(size(d)); end
end

if nargout==0,
  imshow(b), return
end
bout = b;

  
