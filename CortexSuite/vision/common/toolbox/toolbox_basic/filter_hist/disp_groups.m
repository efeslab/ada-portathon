function disp_groups(groups,ids,nr,nc);

np = ids(end);

baseid =1;
for j=1:length(ids),
 mask = zeros(np,1);
 mask(groups(baseid:ids(j))) = 1+mask(groups(baseid:ids(j)));

 subplot(3,3,j);
 ims(mask,nr,nc);
 baseid = 1+ids(j);
end
