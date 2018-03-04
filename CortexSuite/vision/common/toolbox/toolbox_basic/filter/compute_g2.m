function [g,ga,gb,gc] = compute_g2(I,angle)

if (nargin == 1),
  angle = 0;
end

f1 = [0.0094 0.1148 0.3964 -0.0601 -0.9213 -0.0601 0.3964 0.1148 0.0094];
f2 = [0.0008 0.0176 0.166 0.6383 1.0 0.6383 0.166 0.0176 0.0008];
f3 = [-0.0028 -0.048 -0.302 -0.5806 0 0.5806 0.302 0.048 0.0028];

%ga = conv2(conv2(I,f2,'same'),f1','same');
%gb = conv2(conv2(I,f3,'same'),f3','same');
%gc = conv2(conv2(I,f1,'same'),f2','same');

ga = conv2(conv2(I,f1,'same'),f2','same');
gb = conv2(conv2(I,f3,'same'),f3','same');
gc = conv2(conv2(I,f2,'same'),f1','same');

ka = cos(angle)^2;
kb = -2*cos(angle)*sin(angle);
kc = sin(angle)^2;

g = ka*ga + kb*gb + kc*gc;
