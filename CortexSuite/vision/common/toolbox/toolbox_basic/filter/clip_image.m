function J = clip_image(I,w)

[size_y,size_x] = size(I);

J = I(w+1:size_y-w,w+1:size_x-w);

