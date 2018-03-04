function I = norm_inten(J)
%
% I = norm_inten(J)
%   
%     normalize image intensity to the range of 0.0-1.0
%

max_J = max(max(J));
min_J = min(min(J));

I = (J-min_J)/(max_J-min_J);
