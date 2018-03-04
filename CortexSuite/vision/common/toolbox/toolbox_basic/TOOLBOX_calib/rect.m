function [Irec] = rect(I,R,f,c,k,alpha,KK_new);


if nargin < 5,
   k = 0;
   if nargin < 4,
      c = [0;0];
      if nargin < 3,
         f = [1;1];
         if nargin < 2,
            R = eye(3);
            if nargin < 1,
               error('ERROR: Need an image to rectify');
               break;
            end;
         end;
      end;
   end;
end;


if nargin < 7,
   if nargin < 6,
		KK_new = [f(1) 0 c(1);0 f(2) c(2);0 0 1];
   else
   	KK_new = alpha; % the 6th argument is actually KK_new   
   end;
   alpha = 0;
end;



% Note: R is the motion of the points in space
% So: X2 = R*X where X: coord in the old reference frame, X2: coord in the new ref frame.


if ~exist('KK_new'),
   KK_new = [f(1) alpha_c*fc(1) c(1);0 f(2) c(2);0 0 1];
end;


[nr,nc] = size(I);

Irec = 255*ones(nr,nc);

[mx,my] = meshgrid(1:nc, 1:nr);
px = reshape(mx',nc*nr,1);
py = reshape(my',nc*nr,1);

rays = inv(KK_new)*[(px - 1)';(py - 1)';ones(1,length(px))];


% Rotation: (or affine transformation):

rays2 = R'*rays;

x = [rays2(1,:)./rays2(3,:);rays2(2,:)./rays2(3,:)];


% Add distortion:

k1 = k(1);
k2 = k(2);

p1 = k(3);
p2 = k(4);

r_2 = sum(x.^2);

delta_x = [2*p1*x(1,:).*x(2,:) + p2*(r_2 + 2*x(1,:).^2) ;
           p1 * (r_2 + 2*x(2,:).^2)+2*p2*x(1,:).*x(2,:)];

xd = (ones(2,1)*( 1 + k1 * r_2 + k2 * r_2.^2)) .* x + delta_x;


% Reconvert in pixels:

px2 = f(1)*(xd(1,:)+alpha_c*xd(2,:))+c(1);
py2 = f(2)*xd(2,:)+c(2);


% Interpolate between the closest pixels:

px_0 = floor(px2);
px_1 = px_0 + 1;
alpha_x = px2 - px_0;

py_0 = floor(py2);
py_1 = py_0 + 1;
alpha_y = py2 - py_0;

good_points = find((px_0 >= 0) & (px_1 <= (nc-1)) & (py_0 >= 0) & (py_1 <= (nr-1)));

I_lu = I(px_0(good_points) * nr + py_0(good_points) + 1);
I_ru = I(px_1(good_points) * nr + py_0(good_points) + 1);
I_ld = I(px_0(good_points) * nr + py_1(good_points) + 1);
I_rd = I(px_1(good_points) * nr + py_1(good_points) + 1);


I_interp = (1 - alpha_y(good_points)).*((1 - alpha_x(good_points)).* I_lu + alpha_x(good_points) .* I_ru) + alpha_y(good_points) .* ((1 - alpha_x(good_points)).* I_ld + alpha_x(good_points) .* I_rd);


Irec((px(good_points)-1)*nr + py(good_points)) = I_interp;



return;


% Convert in indices:

fact = 3;

[XX,YY]= meshgrid(1:nc,1:nr);
[XXi,YYi]= meshgrid(1:1/fact:nc,1:1/fact:nr);

%tic;
Iinterp = interp2(XX,YY,I,XXi,YYi); 
%toc

[nri,nci] = size(Iinterp);


ind_col = round(fact*(f(1)*xd(1,:)+c(1)))+1;
ind_row = round(fact*(f(2)*xd(2,:)+c(2)))+1;

good_points = find((ind_col >=1)&(ind_col<=nci)&(ind_row >=1)& (ind_row <=nri));
