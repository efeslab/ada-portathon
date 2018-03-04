function J = compute_J(A,I,size_x,size_y,D)
%%  function J = compute_J(A,I,size_x,size_y,D)
%

[center_x,center_y] = find_center(size_x,size_y);

tmp = ones(size_y,1)*[1:size_x];
index(:,1) = reshape(tmp,size_x*size_y,1)-center_x*ones(size_x*size_y,1);
index(:,2) = reshape(tmp',size_x*size_y,1)-center_y*ones(size_x*size_y,1);

position_new = A*index'+ [D(1),0;0,D(2)]*ones(2,size_x*size_y);
position_new = round(position_new +...
 [center_x,0;0,center_y]*ones(2,size_x*size_y));
% we have to deal with out of boundary ones
%
bad_ones(1,:) = position_new(1,:)<1 | position_new(1,:)>size_x;
bad_ones(2,:) = position_new(2,:)<1 | position_new(2,:)>size_y;
bad = max([bad_ones(1,:);bad_ones(2,:)]);
good = ~bad;
% if new index is out of boundary, then set it to (0,0)
position_new(1,:) = position_new(1,:).*good;
position_new(2,:) = position_new(2,:).*good;

new_index = size_y*(position_new(1,:)-ones(1,size_x*size_y))+...
    position_new(2,:);
new_index = max([new_index;ones(1,size_x*size_y)]);
J = I(new_index);
% set the "out of boundary" to zero.
J = J.*good;
J = reshape(J',size_y,size_x);

