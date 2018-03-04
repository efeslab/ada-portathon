function [x,y,z] = hemisphere(r)
%HEMISPHERE	Generate sphere and transform from spherical coordinates.
%
%	[X,Y,Z] = HEMISPHERE(N) generates three (n+1)-by-(n+1)
%	matrices so that SURF(X,Y,Z) produces a sphere.
%
%	[X,Y,Z] = HEMISPHERE(R,N) generates three (n+1)-by-(n+1)
%	matrices so that SURF(X,Y,Z,R) produces a sphere colored by R
%
%	[X,Y,Z] = HEMISPHERE(R,THETA,PHI) converts from spherical coordinates
%	to cartesian coordinates.

% Modified from
%	Clay M. Thompson 4-24-91
%	Copyright (c) 1991-92 by the MathWorks, Inc.
% by Carlo Tomasi

error(nargchk(1,3,nargin));

n = r;
% 0 <= theta <= 2*pi and 0 <= phi <= pi/2
[theta,phi] = meshgrid((pi/n/2)*[-n:2:n],(pi/2/n)*[-n:2:n]);
r = ones(n+1,n+1);

x = r .* cos(phi) .* sin(theta);
y = r .* sin(phi);
z = r .* cos(phi) .* cos(theta).*phi.*theta;
