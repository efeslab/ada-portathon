function a = cutout(I,ct,wz);

a = I(ct(2)-wz(2):ct(2)+wz(2),ct(1)-wz(1):ct(1)+wz(1),:);
