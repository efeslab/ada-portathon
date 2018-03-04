function sgn = makesgn(sigma,sigma_x,sze)


size_wh = round(0.5*sze);
[x,y] = meshgrid([-size_wh(2):1:size_wh(2)],[-size_wh(1):1:size_wh(1)]);
steps = 1/(1+sigma_x);

fx = steps*((x+sigma_x).*(x>-sigma_x).*(x<1)) + steps*(sigma_x-x).*(x<sigma_x).*(x>=1);
sgn = fx.*(exp(- (y.*y)/(2*sigma)));