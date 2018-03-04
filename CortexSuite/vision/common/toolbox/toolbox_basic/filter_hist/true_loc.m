function a = true_loc(loca,g,scale);

if ~exist('scale'),
  scale = 50;
end

y = loca(1,:);
x = loca(2,:);

min_x = min(x);
min_y = min(y);

x = x - min_x;
y = y - min_y;

max_x = max(x);max_y = max(y);
min_scale = min(max_x,max_y);

a(1) = (g(1)-1)*min_scale/(scale);
a(2) = (g(2)-1)*min_scale/(scale);

a(1) = a(1) + min_x;
a(2) = a(2) + min_y;
