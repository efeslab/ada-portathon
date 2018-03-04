function mask = proj_back(I,hw,mask_s)
%
%   mask = proj_back(I,hw,mask_s)
%
%


[nr,nc] = size(I2);

hw = 3;
st_sz = 2*hw + 1;

nr_chank = floor(nr/st_sz);
nc_chank = floor(nc/st_sz);

[x,y] = meshgrid(1:nc,1:nr);

ct_chank_x = round((x-hw-1)/st_sz) + 1;
ct_chank_y = round((y-hw-1)/st_sz) + 1;

idx = (ct_chank_x - 1)*nr_chank + ct_chank_y;

mask = full(sparse(y,x,mask_s(idx(:))));

