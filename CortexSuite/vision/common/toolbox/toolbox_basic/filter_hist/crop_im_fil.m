function [J,f,rect] = crop_im_fil(Ja,Jfa,fig_id)
%
%

figure(fig_id);
imagesc(Ja);axis('image');

[J,rect] = imcrop;rect = round(rect);
J = Ja(rect(2):rect(2)+rect(4),rect(1):rect(1)+rect(3));
f = Jfa(rect(2):rect(2)+rect(4),rect(1):rect(1)+rect(3),:,:);

