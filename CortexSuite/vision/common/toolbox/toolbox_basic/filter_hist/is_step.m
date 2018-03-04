function P_step = is_step(gx,gy)
% 
%   P_step = is_step(gx,gy)
%
%      determine wheter gx,gy(which is first
%      order filter output) is a response
%      to a step function
%

M = zeros(2,2);
M(1,1) = sum(sum(gx.*gx));
M(2,2) = sum(sum(gy.*gy));
M(1,2) = sum(sum(gx.*gy));
M(2,1) = M(1,2);

[v,d] = eig(M);
d = diag(d);

% make the first eig_value to be the smaller one
if (d(2)< d(1)),
   tmp = d(1);d(1) = d(2);d(2) = tmp;
   tmp = v(:,1); v(:,1) = v(:,2); v(:,2) = tmp;
end

ratio = d(1)/d(2);
threshold = 0;
gx_ratio = sum(sum(gx.*(gx>threshold)))/(sum(sum(abs(gx).*(abs(gx)>threshold))));
gx_ratio = max(gx_ratio,1-gx_ratio);

gy_ratio = sum(sum(gy.*(gy>threshold)))/(sum(sum(abs(gy).*(abs(gy)>threshold))));
gy_ratio = max(gy_ratio,1-gy_ratio);

P_step = [ratio,gx_ratio,gy_ratio];
