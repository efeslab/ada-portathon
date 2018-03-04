function [h,ha,hb,hc,hd] = compute_h2(I,angle)

if (nargin == 1),
  angle = 0;
end

f1 = [0.0098 0.0618 -0.0998 -0.7551 0 0.7551 0.0998 -0.0618 -0.0098];
f2 = [ 0.0008 0.0176 0.166 0.6383 1 0.6383 0.166 0.0176 0.0008];
f3 = -[-0.002 -0.0354 -0.2225 -0.4277 0 0.4277 0.2225 0.0354 0.002];
f4 = [0.0048 0.0566 0.1695 -0.1889 -0.7349 -0.1889 0.1695 0.0566 0.0048];

%ha = conv2(conv2(I,f2,'same'),f1','same');
%hb = conv2(conv2(I,f3,'same'),f4','same');
%hc = conv2(conv2(I,f4,'same'),f3','same');
%hd = conv2(conv2(I,f1,'same'),f2','same');

ha = conv2(conv2(I,f1,'same'),f2','same');
hb = conv2(conv2(I,f4,'same'),f3','same');
hc = conv2(conv2(I,f3,'same'),f4','same');
hd = conv2(conv2(I,f2,'same'),f1','same');

ka = cos(angle)^3;
kb = -3*cos(angle)^2*sin(angle);
kc = 3*cos(angle)*sin(angle)^2;
kd = -sin(angle)^3;

h = ka*ha + kb*hb + kc*hc + kd*hd;
