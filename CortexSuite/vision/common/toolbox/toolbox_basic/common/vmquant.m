function [im, map] = vmquant(arg1,arg2,arg3,arg4,arg5,arg6,arg7)
%VMQUANT Variance Minimization Color Quantization.
%	[X, MAP] = VMQUANT(R,G,B,K,[Qr Qg Qb],DITHER,Qe) or
%	VMQUANT(RGB,K,[Qr Qg Qb],DITHER,Qe), where RGB is a 3-D array, 
%	converts an arbitrary image comprised of RGB triples into an 
%	indexed image X with color map MAP.  K specifies the number 
%	of desired entries in the target color map, and [Qr Qg Qb] 
%	specifies the number of quantization bits to assign each color 
%	axis during color interpolation.  DITHER is a string ('dither' or
%	'nodither') that indicates whether or not to perform error propagation 
%	dither on the output image.  Qe specifies the number of bits of
%	quantization used in the error calculations.
%
%	K is optional and defaults to 256.
%	[Qr Qg Qb] is optional and defaults to [5 5 5].
%	DITHER is optional and defaults to 'nodither'.
%	Qe is optional and defaults to 8.
%
%	See also: RGB2IND, RGB2GRAY, DITHER, IND2RGB, CMUNIQUE, IMAPPROX.

%	This is the wrapper function for the MEX file VMQUANTC.C

%	Joseph M. Winograd 6-93
%	Copyright (c) 1993 by The MathWorks, Inc.
%	$Revision: 5.3 $  $Date: 1996/08/22 22:09:03 $

%	Reference: Xiaolin Wu, "Efficient Statistical Computation for
%	Optimal Color Quantization," Graphics Gems II, (ed. James
%	Arvo).  Academic Press: Boston. 1991.

if nargin < 1,
  error('Not enough input arguments.');
end

threeD = (ndims(arg1)==3); % Determine if input includes a 3-D array

if threeD,
  error( nargchk( 1, 5, nargin ) );

			% NOTE: If you change defaults, change them also
			%	in VMQUANTC.C and recompile the MEX function.
  if nargin < 5
      arg5 = 8;		% DEFAULT_QE = 8
  end

  if nargin < 4
      arg4 = 'n';		% DEFAULT_DITHER = 0
  end

  if nargin < 3
      arg3 = [5 5 5];	% DEFAULT_Q = [5 5 5]
  end

  if nargin < 2
      arg2 = 256;		% DEFAULT_K = 256
  end

  rout = arg1(:,:,1);
  g = arg1(:,:,2);
  b = arg1(:,:,3); 

  if strcmp(lower(arg4(1)),'d')
    dith = 1;
  else
    dith = 0;
  end
  
  arg7 = arg5;
  arg5 = arg3;
  arg4 = arg2;

else
  error( nargchk( 3, 7, nargin ) );

  if nargin < 7
      arg7 = 8;		% DEFAULT_QE = 8
  end

  if nargin < 6
      arg6 = 'n';		% DEFAULT_DITHER = 0
  end

  if nargin < 5
      arg5 = [5 5 5];	% DEFAULT_Q = [5 5 5]
  end

  if nargin < 4
      arg4 = 256;		% DEFAULT_K = 256
  end

  rout = arg1;
  g = arg2;
  b = arg3;

  if strcmp(lower(arg6(1)),'d')
    dith = 1;
  else
    dith = 0;
  end

end

if (~isa(rout,'uint8'))
  rout = uint8(round(255*rout));
end
if (~isa(g,'uint8'))
  g = uint8(round(255*g));
end
if (~isa(b,'uint8'))
  b = uint8(round(255*b));
end
[im,map] = vmquantc( rout, g, b, arg4, arg5, dith, arg7 );
