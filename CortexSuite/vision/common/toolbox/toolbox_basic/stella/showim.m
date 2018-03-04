% function showim(f,cmap) display real or complex image.
% When it is complex, the real part and imaginary part
% are displayed as [real,imag] in one image.
% cmap is the colormap. default = gray, -1 = inverted gray.

% Stella X. Yu, 2000. 

function showim(f,cmap,ishori)

if not(isreal(f)),
   i = [real(f(:)); imag(f(:))];
   j = [min(i), max(i)];
   [nr,nc] = size(f);
   if nargin<3 | isempty(ishori),
      ishori =  nr>nc;
   end
   if ishori,
      i = zeros(nr,1);
      f = [real(f), [i+j(1),i+j(2)], imag(f)];
   else
      i = zeros(1,nc);
      f = [real(f); [i+j(1);i+j(2)]; imag(f)];
   end
end
imagesc(f); axis off; axis image; 

if nargin<2 | isempty(cmap),
   return;
end

if cmap==1,
   cmap = gray;
elseif cmap==-1,
   cmap = flipud(gray);
end
colormap(cmap);