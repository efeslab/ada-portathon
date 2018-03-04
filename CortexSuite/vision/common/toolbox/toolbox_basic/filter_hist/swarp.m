function J = swarp(I)

[nr,nc] = size(I);

center_x = round(0.5*nc);
center_y = round(0.5*nr);

J = [I(center_y:nr,center_x:nc),I(center_y:nr,1:center_x-1);...
     I(1:center_y-1,center_x:nc),I(1:center_y-1,1:center_x-1)];	