function I = gen_feature_s(size_of_feature)
% function I = gen_feature(size_of_feature)
%  generates a spherical features with size
% of "size_of_feature"
%

ss = round(0.4*size_of_feature);
[X,Y,II] = hemisphere_s(ss);

II = abs(II);
II = 1/max(max(II))*II;

I = zeros(size_of_feature,size_of_feature);

t = round((size_of_feature-ss)/2);

I(1+t:1+t+ss,1+t:1+t+ss) = II;
