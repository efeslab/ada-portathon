load patch1;
doog2 = mkdoog2(2,10,0,80);
dog2 = rotate_J(90,doog2);

H = mkf_test(dog2,size(patch1),-1,0.00001,2,-1);
o = BfilterS(patch1,H,size(dog));figure(4);colormap(gray);imagesc(o.*(o>0));