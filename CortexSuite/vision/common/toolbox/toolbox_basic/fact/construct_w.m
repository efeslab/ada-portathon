function W = construct_w(centers,Ds,img_center,indexes,frames)
%
%  function W = construct_w(centers,Ds,img_center,indexes,frames)
%   optional: frames
%  


points = length(indexes);
if (nargin == 4),
 frames = 0.5*size(centers,2);
end

W = zeros(2*frames,points);

center_x = img_center(1);
center_y = img_center(2);

for j=1:frames,
  % x is centers(:,2*j-1)
  % y is centers(:,2*j)
  % d is Ds(:,2*j-1)
  W(j,:) = (centers(indexes,2*j-1) -center_x)'./Ds(indexes,2*j-1)';
  W(j+frames,:) = (centers(indexes,2*j) -center_y)'./Ds(indexes,2*j-1)'; 
 % W(j+2*frames,:) = ones(1,points)./Ds(indexes,2*j-1)';
end