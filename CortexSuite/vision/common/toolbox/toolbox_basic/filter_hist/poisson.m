function [x] = Poisson(lambda);
%Poisson        generates a random variable with a Poisson
%               distribution
%               Pr(x = n) = lambda^n exp(-lambda)/n
%
%               [x] = Poisson(lambda);
%               lambda: the parameter for the Poisson distribution
%                       (default is 1)
%               x     : the output number
%

%%
%%              (C) Thomas K. Leung
%%              University of California at Berkeley
%%              Apr 25, 1995.
%%

%%% Notice that in this implementation, we are comparing log(Z) with
%%% T.  In fact, we can compare T = exp(-lambda) with Z, which will
%%% save us from computing a large number of log's.  However, when
%%% lambda is bigger than 709, exp(-lambda) = 0, which causes problem. 

if nargin == 0
        lambda = 1;
end

if lambda < 0
        lambda = 1;
end

P = 0;
N = 0;
T = -lambda;

rand('seed',sum(100*clock));

while P >= T
        Z = rand(1);
        P = P + log(Z);
        N = N + 1;
end

x = N;

