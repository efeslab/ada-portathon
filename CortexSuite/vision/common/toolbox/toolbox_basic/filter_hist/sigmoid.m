function a = sigmoid(x,offset,sig)
%
%   a = sigmoid(x,offset,sig)
%      
%       a = ones(size(x))./(1+exp(-(x-offset)/sig));
%


a = ones(size(x))./(1+exp(-(x-offset)/sig));

