function BI = back_proj(PFt,vec)

BI = [];

sz1 = sqrt(size(PFt,1));

for j=1:size(vec,2)
  tmp = PFt*vec(:,j);
  BI(:,:,j) = reshape(tmp,sz1,sz1);
end
