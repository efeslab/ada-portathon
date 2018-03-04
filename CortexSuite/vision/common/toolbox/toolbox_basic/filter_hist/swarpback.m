function J = swarpback(I);

[nr,nc] = size(I);

center_x = round(0.5*nc);
center_y = round(0.5*nr);

cx= center_x -1;
cy= center_y -1;

J = [I(nr-cy+1:nr,nc-cx+1:nc),I(nr-cy+1:nr,1:(nc-center_x+1));...
     I(1:(nr-center_y+1),nc-cx+1:nc),I(1:(nr-center_y+1),1:(nc-center_x+1))];