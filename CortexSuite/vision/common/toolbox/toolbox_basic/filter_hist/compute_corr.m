function a = compute_corr(f,g)
%
%  compute the circular correlation of f and g
%  at points around zero
%
%

ff = interp(f,4);
gg = interp(g,4);

