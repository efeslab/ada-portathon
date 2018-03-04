function [filt] = bars(X,Y,ks);
%FIL1	the first filter to use has the following specifications:
%
% 	real part: 2nd derivative of gaussian along Y
%		   normal gaussian along X
%	This filter is elongated along the X direction
%	imag part: hilbert transform of the real part
%
%	[filt] = fil1(X,Y,ks);
%	X,Y  : index matrix obtained by meshgrid
%	ks   : kernel size
%	filt : the output kernel
%

%%
%%	(c) Thomas Leung
%%	California Institute of Technology
%%	Feb 27, 1994.
%%

if(nargin == 2)
	ks = 17;
end

sigmay = 2.4 * ks / 17;
sigmax = 3 * sigmay;

fxr = exp(-(X/sigmax).^2/2);
fyr = (1/sigmay^2) * ((Y/sigmay).^2-1) .* exp(- (Y/sigmay).^2/2);
nrm = 1/(sigmax*sigmay*2*pi);

% real part of filter
fr = nrm * fxr .* fyr;

% imag part of filter
filt = hilbert(fr);


return;
