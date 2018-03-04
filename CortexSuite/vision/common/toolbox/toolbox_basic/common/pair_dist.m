function W  = pari_hist_dist_fast(data)
%
%  W  = pari_hist_dist(data)
%
%        data: num_im by num_feature 
%        W  : num_im by num_im hist diff
%

[num_im,num_feature] = size(data);
mag = sum(data.*data,2);

W = mag(:,ones(1,num_im))  - 2*data*data';
mag = mag';
W = W+mag(ones(num_im,1),:);
