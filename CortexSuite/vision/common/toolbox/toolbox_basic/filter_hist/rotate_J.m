function J = compute_J(angle,I)
%%  function J = compute_J(angle,I)
%

[size_y,size_x] = size(I);

[center_x,center_y] = find_center(size_x,size_y);

a = angle * pi/180;
A = [cos(a),-sin(a);sin(a),cos(a)];

[XX,YY] = meshgrid(1:size_x,1:size_y);

x = reshape(XX,size_x*size_y,1);
y = reshape(YY,size_x*size_y,1);
index(:,1) = x-center_x;
index(:,2) = y-center_y;

position_new = A*index';
position_new(1,:) = position_new(1,:)+center_x;
position_new(2,:) = position_new(2,:)+center_y;

position_new_x = reshape(position_new(1,:),size_y,size_x);
position_new_y = reshape(position_new(2,:),size_y,size_x);

J = m_interp4(I,position_new_x,position_new_y);




