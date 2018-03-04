% function dispimg(g,fmt,lgd,cmap) display multiple images in one figure. 
% Input:
%    g = a cell and fmt is a 1x2 vector specifying the layout.
%    lgd = a string cell for the title of each image. 
%    cmap = the colormap (default is the gray, -1 for the inverted gray).
%    ishori = a vector of 1/0 to display real and imag parts horizontally / vertically

% Stella X. Yu, 2000.

function dispimg(g,fmt,lgd,cmap,ishori);

cellg = iscell(g);
if cellg,
    num_fig = length(g);
else
    num_fig = size(g,3);
end;

if nargin<2 | isempty(fmt),
    m = ceil(sqrt(num_fig));
    n = ceil(num_fig / m);
else
    m = fmt(1);
    n = fmt(2);
end

if nargin<3 | isempty(lgd),
    lgd = 1:num_fig;
end 
if isnumeric(lgd),
   lgd = cellstr(num2str(lgd(:),3)); 
end
i = size(lgd);
if i(1)==1,
   lgd = [lgd, cell(1,num_fig-i(2))];
else
   lgd = [lgd; cell(num_fig-i(1),1)];
end

if nargin<5 | isempty(ishori),
   ishori = ones(num_fig,1);
end
ishori(end+1:num_fig) = ishori(end);

for k=1:num_fig,
    subplot(m,n,k);
    if cellg,
        showim(g{k},[],ishori(k));
    else
        showim(g(:,:,k),[],ishori(k));
    end
    title(lgd{k});
end

if nargin<4 | isempty(cmap),
   cmap = gray;
end
if length(cmap)==1,
   if cmap==1,
      cmap = gray;
   else
      cmap = flipud(gray);
   end
end
colormap(cmap);
