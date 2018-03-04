function J = get_win5(I,center,wc)
%
%   J = get_win5(I,center,wc)
%
%        center: [x,y]



J = I(center(2)-wc(2):center(2)+wc(2),...
      center(1)-wc(1):center(1)+wc(1),:,:);

