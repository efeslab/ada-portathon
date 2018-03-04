function [a,phi1,phi2] = compute_diff_patch(gx1,gy1,gx2,gy2,I1,I2)
%
%    a = compute_diff_patch(gx1,gy1,gx2,gy2,I1,I2)
%
%

%ws = size(gx1);
%mask = smooth(ones(ws),2*max(ws));
%mask = mask/sum(sum(mask));

%mag1= sum(sum(sqrt((mask.*gx1).^2 + (mask.*gy1).^2)));
%mag2= sum(sum(sqrt((mask.*gx2).^2 + (mask.*gy2).^2)));

mag1= sum(sum(sqrt((gx1).^2 + (gy1).^2)))/prod(size(gx1));
mag2= sum(sum(sqrt((gx2).^2 + (gy2).^2)))/prod(size(gx1));

P_tx1 = sigmoid(mag1,2,0.5);
P_tx2 = sigmoid(mag2,2,0.5);

diff_I = mean(reshape(I1,prod(size(I1)),1))-...
         mean(reshape(I2,prod(size(I2)),1));
diff_I = abs(diff_I);

[l1,l2,phi1] = mwis(gx1,gy1);
[k1,k2,phi2] = mwis(gx2,gy2);

ratio1 = min([l1,l2])/max([l1,l2]);
ratio2 = min([k1,k2])/max([k1,k2]);

r1 = 1-sigmoid(ratio1,0.35,0.05);
r2 = 1-sigmoid(ratio2,0.35,0.05);

s1 = [cos(phi1),sin(phi1)];
s2 = [cos(phi2),sin(phi2)];

angle = acos(abs(dot(s1,s2)))*180/pi;

a1 = (1-P_tx1*P_tx2)*exp(-diff_I/0.1);
a2 = P_tx1*P_tx2*(r1*r2*(90-angle)/90);
a3 = P_tx1*P_tx2*((1-r1*r2)*(1-sigmoid(abs(r1-r2),0.3,0.04)));

a = a1+a2+a3;



