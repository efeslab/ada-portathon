function masks = make_masks(groups,ids,nr,nc);

np = ids(end);

baseid =1;
for j=1:length(ids),
 mask = zeros(np,1);
 mask(groups(baseid:ids(j))) = 1+mask(groups(baseid:ids(j)));
 baseid = 1+ids(j);

 masks(:,:,j) = mask;
end
