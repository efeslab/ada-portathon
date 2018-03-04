function T = patch_cat(dotfilter,text_des)

T(:,:,2:7,:) = text_des;
clear text_des;

for k=1:size(T,4),
  T(:,:,1,k) = dotfilter(:,:,1,k);
end

