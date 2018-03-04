function J = im_vd(I);

J(:,:,1) = I(1:2:end,1:2:end);
J(:,:,2) = I(2:2:end,1:2:end);

montage2(J);
