function a = half_sigmoid(x,offset,sig)
%
%   a = half_sigmoid(x,offset,sig)
%      
%       a = ones(size(x))./(1+exp(-(x-offset)/sig));
%
%   keep the sign of a

sign_x = sign(x);
x = abs(x);

a = ones(size(x))./(1+exp(-(x-offset)/sig));

off = 1/(1+exp(-(0-offset)/sig));

a = sign_x.*(a-off);

