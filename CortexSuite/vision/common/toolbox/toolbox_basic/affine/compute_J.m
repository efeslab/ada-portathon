function [JJ,mask] = compute_J(A,D,I,center,window_size_h)
%%  function J = compute_J(A,D,I,center,window_size_h)
%

[size_y,size_x] = size(I);

center_x = center(1);
center_y = center(2);

[XX,YY] = meshgrid(1:size_x,1:size_y);
x = reshape(XX,size_x*size_y,1);
y = reshape(YY,size_x*size_y,1);
index(:,1) = x-center_x;
index(:,2) = y-center_y;

position_new = A*index'+ [D(1),0;0,D(2)]*ones(2,size_x*size_y);
position_new(1,:) = position_new(1,:)+center_x;
position_new(2,:) = position_new(2,:)+center_y;

position_new_x = reshape(position_new(1,:),size_y,size_x);
position_new_y = reshape(position_new(2,:),size_y,size_x);

[J,mask]= m_interp4(I,position_new_x,position_new_y);

JJ = J(center(2)-window_size_h(2):center(2)+window_size_h(2),...
       center(1)-window_size_h(1):center(1)+window_size_h(1));
mask = mask(center(2)-window_size_h(2):center(2)+window_size_h(2),...
       center(1)-window_size_h(1):center(1)+window_size_h(1));



