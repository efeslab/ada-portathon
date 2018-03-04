function [x,y,success] = PoissonField(int,sx,sy,ir);
%BF_HardCore	Generates a hard core Poisson field
%		[x,y] = Poisson_HC(int,ir,sx,sy);
%		int: intensity of the field.  (default is 1)
%		ir : inhibition radius (default is 1)
%		sx : size in x (default 100)
%		sy : size in y (default 100)
%		x  : x coordinates
%		y  : y coordinates
%

%%
%%		(C) Thomas K. Leung
%%		University of California at Berkeley
%%		April 26, 1995.
%%		leungt@cajal.cs.berkeley.edu
%%

%%
%% Generate each point in sequence and reject it if it's too close to
%% previous ones. 
%%

if nargin <= 0
	int = 1; 
	sx  = 100;
	sy  = 100;
	ir  = 0;
elseif nargin <= 1
	sx  = 100;
	sy  = 100;
	ir  = 0;
elseif nargin <= 2
	sy = 100;
	ir = 0;
elseif nargin <= 3
	ir = 0;
end

%% 
%% Notice that the average number of a poisson process is the
%% parameter lambda.  This is consistent with our definition of the
%% intensity here.  Intensity is the mean number of points inside each
%% unit area.  Therefore, in a window of sx by sy, we should get
%% int*sx*sy number of points on average which is the mean number of
%% arrivals in a Poisson Process
%%

[n] = poisson(int * sx * sy);

[x,y,success] = binomialfield(n,sx,sy,ir);


