function [diffI,corr,mag,theta] = get_diff2(I,J,w)
% car: I
% background: J

% half window size
if (nargin == 2)
 w = 1;
end

[gIx,gIy] = grad2(I,w);
[gJx,gJy] = grad2(J,w);
gx = gIx;
gy = gIy;

% normalize
sI= sqrt(gIx.*gIx+gIy.*gIy);
sJ= sqrt(gJx.*gJx+gJy.*gJy);
gIx = gIx./sI;
gIy = gIy./sI;
gJx = gJx./sJ;
gJy = gJy./sJ;

theta = cart2pol(gIy,gIx);
corr = gIx.*gJx + gIy.*gJy;

%[gx,gy]= grad((I-J),w);mag = sqrt(gx.*gx+gy.*gy);
%mag = sI;


mag = sqrt((cos(theta).^2).*gy.^2 + (sin(theta).^2).*gx.^2 +...
      2*cos(theta).*sin(theta).*gx.*gy);

% want to look at the grad. mag greater than 10, and corr less than 0.9
threshold = max(3.5,0.1*max(max(mag(5:size(mag,1)-5,5:size(mag,2)-5))))
diffI = (abs(corr)<0.85).*(mag>threshold);








