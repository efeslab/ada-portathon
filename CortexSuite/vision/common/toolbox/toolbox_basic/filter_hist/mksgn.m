function sgn = makesgn(sigma,sigma_x,sze)


size_wh = round(0.5*sze);
[x,y] = meshgrid([-size_wh:1:size_wh],[-size_wh:1:size_wh]);
steps = 1/(1+2*sigma_x);

fx = -1*(x<=-sigma_x) + (x>=sigma_x) + steps*((x+sigma_x).*(x>-sigma_x).*(x<sigma_x));

sgn = fx.*(exp(- (y.*y)/(2*sigma)));