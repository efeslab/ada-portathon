function showInterestPoints(im, x, y)
% show 'em
imagesc(im);
colormap(gray);
hold on;
plot(x,y,'r.');
hold off;