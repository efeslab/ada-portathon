function a = im_vect(loca,v,scale);

if ~exist('scale'),
  scale = 50;
end

y = loca(1,:);
x = loca(2,:);

x = x - min(x);
y = y - min(y);

max_x = max(x);max_y = max(y);
min_scale = min(max_x,max_y);

x = scale*x/min_scale;
y = scale*y/min_scale;


a = sparse(y+1,x+1,v);
