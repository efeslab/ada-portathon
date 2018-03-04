function imvs(I,v,nr,nc)

v = reshape(v,nr,nc);
im(I(1:size(v,1),1:size(v,2)).*v);