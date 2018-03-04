function a = remap_angle(theta,min,max)

a = (theta<=min).*(theta+pi) + (theta>=max).*(theta-pi) +...
           ((theta>min)&(theta<max)).*theta;