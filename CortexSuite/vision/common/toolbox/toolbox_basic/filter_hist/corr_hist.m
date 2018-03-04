function alpha = corr_hist(hists)

[y,x,v] = find(hists);
mx = sum(x.*v)/sum(v);
my = sum(y.*v)/sum(v);

top = sum( (x-mx).*(y-my).*v);
bottom = sqrt(sum( ((x-mx).^2).*v))*sqrt(sum( ((y-my).^2).*v));
alpha = top/bottom;
