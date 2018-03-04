function [angle,mag,c2,c3] = compute_angle(I)

[g,ga,gb,gc] = compute_g2(I,0); 
[h,ha,hb,hc,hd] = compute_h2(I,0);

c2 = 0.5*(ga.^2 - gc.^2) + 0.46875*(ha.^2 - hd.^2) +...
     0.28125*(hb.^2 - hc.^2) + 0.1875*(ha.*hc - hb.*hd);

c3 = -ga.*gb - gb.*gc - 0.9375*(hc.*hd + ha.*hb) -...
  1.6875*hb.*hc - 0.1875*ha.*hd;

[angle,mag] = cart2pol(-c2,-c3);

%angle = angle/2+pi/2;
%angle = (angle>pi).*(angle-2*pi) + (angle<=pi).*angle;

angle = angle/2;
mag = sqrt(mag);