%SAVEPPM	Write a PPM format file
%
%	SAVEPPM(filename, r, g, b)
%
%	Saves the specified red, green and blue planes in a binary (P6)
%	format PPM image file.
%
% SEE ALSO:	loadppm
%
%	Copyright (c) Peter Corke, 1999  Machine Vision Toolbox for Matlab


% Peter Corke 1994

function saveppm(fname, R, G, B)

	fid = fopen(fname, 'w');
	[r,c] = size(R');
	fprintf(fid, 'P6\n');
	fprintf(fid, '%d %d\n', r, c);
	fprintf(fid, '255\n');
	im = [R(:) G(:) B(:)];
	im = reshape(c,r);
	fwrite(fid, im, 'uchar');
	fclose(fid)
