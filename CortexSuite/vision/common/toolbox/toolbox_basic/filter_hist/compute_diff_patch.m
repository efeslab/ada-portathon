function a = compute_diff_patch(gx1,gy1,gx2,gy2,I1,I2)
%
%    a = compute_diff_patch(gx1,gy1,gx2,gy2,I1,I2)
%
%

%ws = size(gx1);
%mask = smooth(ones(ws),2*max(ws));
%mask = mask/sum(sum(mask));

%mag1= sum(sum(sqrt((mask.*gx1).^2 + (mask.*gy1).^2)));
%mag2= sum(sum(sqrt((mask.*gx2).^2 + (mask.*gy2).^2)));

mag1= sum(sum(sqrt((gx1).^2 + (gy1).^2)));
mag2= sum(sum(sqrt((gx2).^2 + (gy2).^2)));

P_tx1 = sigmoid(mag1,400,80);
P_tx2 = sigmoid(mag2,400,80);

diff_I = mean(reshape(I1,prod(size(I1)),1))-...
         mean(reshape(I2,prod(size(I2)),1));
diff_I = abs(diff_I);

s_g1 = [sum(sum(abs(gx1))),sum(sum(abs(gy1)))];
s_g2 = [sum(sum(abs(gx2))),sum(sum(abs(gy2)))];

s_g1 = s_g1/(norm(s_g1));
s_g2 = s_g2/(norm(s_g2));

a = (1-P_tx1)*(1-P_tx2)*exp(-diff_I/0.1) +...
    P_tx1*P_tx2*(dot(s_g1,s_g2));



