function [F,mask] = m_interp4(z,s,t)
%INTERP4 2-D bilinear data interpolation.
%       ZI = INTERP4(Z,XI,YI) assumes X = 1:N and Y = 1:M, where
%       [M,N] = SIZE(Z).
%
%       Copyright (c) 1984-93 by The MathWorks, Inc.
%       Clay M. Thompson 4-26-91, revised 7-3-91, 3-22-93 by CMT.
%
%  modified to 

 
[nrows,ncols] = size(z);


if any(size(z)<[3 3]), error('Z must be at least 3-by-3.'); end
if size(s)~=size(t), error('XI and YI must be the same size.'); end

% Check for out of range values of s and set to 1
sout = find((s<1)|(s>ncols));
if length(sout)>0, s(sout) = ones(size(sout)); end

% Check for out of range values of t and set to 1
tout = find((t<1)|(t>nrows));
if length(tout)>0, t(tout) = ones(size(tout)); end

% Matrix element indexing
ndx = floor(t)+floor(s-1)*nrows;

% Compute intepolation parameters, check for boundary value.
d = find(s==ncols); 
s(:) = (s - floor(s));
if length(d)>0, s(d) = s(d)+1; ndx(d) = ndx(d)-nrows; end

% Compute intepolation parameters, check for boundary value.
d = find(t==nrows);
t(:) = (t - floor(t));
if length(d)>0, t(d) = t(d)+1; ndx(d) = ndx(d)-1; end
d = [];

% Now interpolate, reuse u and v to save memory.
F =  ( z(ndx).*(1-t) + z(ndx+1).*t ).*(1-s) + ...
     ( z(ndx+nrows).*(1-t) + z(ndx+(nrows+1)).*t ).*s;

mask = ones(size(z));

% Now set out of range values to zeros.
if length(sout)>0, F(sout) = zeros(size(sout));mask(sout)=zeros(size(sout));end
if length(tout)>0, F(tout) = zeros(size(tout));mask(tout)=zeros(size(tout));end

