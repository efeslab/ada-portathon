function [x,y,success] = BinomialField(n,sx,sy,ir,numtri);
%BF_HardCore	Generates a hard core binomial field
%		[x,y,success] = BinomialField(n,sx,sy,ir);
%		n      : # points (default 100)
%		sx     : size in x (default 100)
%		sy     : size in y (default 100)
%		ir     : inhibition radius (default 0)
%		numtri : number of trials (default 200)
%		x      : x coordinates
%		y      : y coordinates
%		success: whether success or not, useful when producing hard core model

%%
%%		(C) Thomas K. Leung
%%		University of California at Berkeley
%%		April 26, 1995.
%%		leungt@cajal.cs.berkeley.edu
%%

%%
%% Generate n points first and then reject those closer to the
%% previous points than ir
%%

if nargin < 1
	n  = 100;
	sx = 100;
	sy = 100;
	ir = 0;
	numtri = 200;
elseif (nargin == 1 | nargin == 2)
	sx = 100;
	sy = 100;
	ir = 0;
	numtri = 200;
elseif (nargin == 3)
	ir = 0;
	numtri = 200;
elseif (nargin == 4)
	numtri = 200;
end

x = zeros(1,n);
y = zeros(1,n);

rand('seed',sum(100*clock));
x(1) = rand(1) * sx;
y(1) = rand(1) * sy;

success = 1;

I = 2;
trial = 0;
while (I <= n & trial < numtri)
	found = 0;
	trial = 0;
	while (~found & trial < numtri);
		tx = rand(1) * sx;
		ty = rand(1) * sy;
		D  = (x(1:(I-1)) - tx).^2 + (y(1:(I-1)) - ty).^2;
		if sum(D > (ir^2)) == (I-1)
			found = 1;
			x(I) = tx;
			y(I) = ty;
		end
		trial = trial + 1;
	end
	I = I + 1;
end

if trial >= numtri
	fprintf(1,'Failed to generate a point in %d trials\n',numtri);
	success = 0;
end

