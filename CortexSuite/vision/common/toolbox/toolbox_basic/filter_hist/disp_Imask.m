function Imasks = disp_Imask(Is,nr,nc,hw,masks)
%
%   Imasks = disp_Imask(Is,nr,nc,hw,masks)
%

%hw = 2; %nr = 43;nc=68;
gap = 2*hw+1;

x = [1:nc*gap];
y = [1:nr*gap];

xs = (x-hw-1)/gap + 1;ys = (y-hw-1)/gap + 1;

for gid=1:size(masks,3),
  tmp = interp2(reshape(masks(:,:,gid),nr,nc),xs,ys');
  
  Imasks(:,:,gid) = (tmp>0.52).* ((Is).^0.8);
  subplot(3,3,gid);
  im(Imasks(:,:,gid));
end
