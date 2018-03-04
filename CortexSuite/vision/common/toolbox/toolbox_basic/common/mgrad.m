function [dx,dy] = mgrad(I,w)
%
%  [dx,dy] = mgrad(I,w)
%

[nr,nc] = size(I);

dx = zeros(nr,nc);dy = zeros(nr,nc);

dx(:,1:nc-w) = I(:,1:nc-w) - I(:,w+1:nc);
dy(1:nr-w,:) = I(1:nr-w,:) - I(w+1:nr,:);
