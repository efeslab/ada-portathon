function H2 = hist2d(J,Jf,scales,filter_ids)

ns = length(scales);
nf = length(filter_ids);

H2 = [];
for j=1:ns,
  for k=1:nf,
      H2d = hist_I_f(J,Jf(:,:,filter_ids(k),scales(j)));
      H2(:,:,j,k) = H2d;
  end
end

