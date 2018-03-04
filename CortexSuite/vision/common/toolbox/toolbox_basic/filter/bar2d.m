function kernel = bar2d(sigx,sigy,siz,angle)

X = -siz:.1:siz;
G = exp(-0.5*X.^2/sigx^2);

DGG = (1/sigy^2) * ((X/sigy).^2-1) .* exp(- (X/sigy).^2/2);
%DGG = (X.^2/(sqrt(2*pi)*sigy^5) - 1/(sqrt(2*pi)*sigy^2)) .* ...
%      exp(-0.5*X.^2/sigy^2);

K = G'*DGG;
K = rotate_J(angle,K);

K = imresize(K,0.1);
K = K-mean(mean(K));

kernel = K;