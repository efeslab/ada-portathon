function J = compute_J(I,A,D,base)
%%  function J = compute_J(I,A,D)
%

if nargin == 3,
  base = -1;
end

[size_y,size_x] = size(I);
[center_x,center_y] = find_center(size_x,size_y);

add_x = round(size_x*0.45);
add_y = round(size_y*0.45);
big_I = base*ones(size_y+2*add_y,size_x+2*add_x);

big_I(add_y+1:add_y+size_y,add_x+1:add_x+size_x) = I;

center_x = add_x+ center_x;
center_y = add_y+ center_y;
[size_y,size_x] = size(big_I);

%a = angle * pi/180;
%A = [cos(a),-sin(a);sin(a),cos(a)];

[XX,YY] = meshgrid(1:size_x,1:size_y);

x = reshape(XX,size_x*size_y,1);
y = reshape(YY,size_x*size_y,1);
index(:,1) = x-center_x;

%index(:,2) = (size_y+1) - y;
index(:,2) = y-center_y;

position_new = A*index';
position_new(1,:) = position_new(1,:)+D(1)+center_x;
position_new(2,:) = position_new(2,:)+D(2)+center_y;
%position_new(2,:) = (size_y+1) - position_new(2,:);

position_new_x = reshape(position_new(1,:),size_y,size_x);
position_new_y = reshape(position_new(2,:),size_y,size_x);

J = m_interp4(big_I,position_new_x,position_new_y);


[size_y,size_x] = size(I);
J = J(add_y+1:add_y+size_y,add_x+1:add_x+size_x);




