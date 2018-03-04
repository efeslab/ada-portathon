% function openfigure(m,n,caption,isnew)
function h = openfigure(m,n,caption,isnew)

if nargin<3,
    caption = ' ';
end

if nargin<4,
    isnew = 1;
end

if (m<=0 | n<=0)
    return;
end

if isnew,
    h = figure; colormap(gray);
else
    h = gcf;
end
clf

subplot('position',[0,0,0.1,0.1]); axis off;
text(0.1,0.15,sprintf('S. X. Yu, %s',date),'FontSize',8);

subplot('position',[0,0.96,0.1,0.1]); axis off;
text(0.1,0.15,caption,'FontSize',8);

subplot(m,n,1); 
%return

if (m==1 & n==1),
    return;
end

%set(gcf,'PaperPosition',[0.25, 8, 8,2.5*m]);
%     set(gcf,'PaperPosition',[0.25,0.25,8,10.5]);
%return

if (m<=n),
     set(gcf,'PaperOrientation','landscape','PaperPosition',[0.25,0.25,10.5,8]);
else
     set(gcf,'PaperPosition',[0.25,0.25,8,10.5]);
end

% comment on PaperPosition
% [a,b,c,d]
% (a,b) is the coordinate of the lower-left corner of the figure
% (a,b) = (0,0) is the lower-left corner of the paper
% (c,d) is the coordinate of the upper-right corner of the figure relative to the lower-left corner of the figure
% Therefore, c>=a, d>=b
% Full paper position would be [0,0,8.5,11] in inches
