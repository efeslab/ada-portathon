function img = carve_it(I,center,window_size_h)

[size_y,size_x]= size(I);
min_x = round(center(1)-window_size_h(1));
max_x = round(center(1)+window_size_h(1));
min_y = round(center(2)-window_size_h(2));
max_y = round(center(2)+window_size_h(2));
window_size = window_size_h*2 +1;

if (min_x <1)|(max_x > size_x)|(min_y<1)|(max_y>size_y),
  disp('window too big');
  center
  window_size_h
  img = zeros(window_size(2),window_size(1));
  n_min_x = max(1,round(min_x));
  n_min_y = max(1,round(min_y));
  n_max_x = min(size_x,round(max_x));
  n_max_y = min(size_y,round(max_y));
  img(1+(n_min_y-min_y):window_size(2)-(max_y-n_max_y),1+(n_min_x-min_x):window_size(1)-(max_x-n_max_x))=I(n_min_y:n_max_y,n_min_x:n_max_x);
else
  img = I(center(2)-window_size_h(2):center(2)+window_size_h(2),...
        center(1)-window_size_h(1):center(1)+window_size_h(1));
end


