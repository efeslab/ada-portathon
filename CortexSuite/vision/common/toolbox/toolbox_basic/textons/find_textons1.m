function [centers,label,post,d2]=find_textons(fv,ncenters,centers_in,n_iter);
% [centers,label,post,d2]=find_textons(FIw,ncenters,centers_in,n_iter);
% 
% find textons using kmeans for windowed portion FIw of filtered image 
%
% to start with centers pulled randomly from image, set centers_in=[]

[N1,N2] =size(fv);

% take centers randomly from within image
if isempty(centers_in)
   rndnum=1+floor(N1*rand(1,ncenters));
   centers_in=fv(rndnum,:);
end

options = foptions;
options(1)=1;		% Prints out error values.
options(5) = 0;
if nargin<4
   n_iter=15;
end
options(14) = n_iter;		% Number of iterations.

[centers,options,d2,post]=kmeans2(centers_in,fv,options);


% retrieve cluster number assigned to each feature vector
[minval,label]=min(d2,[],2);


h = hist(label(:),[1:max(label(:))]);
a = h>0;
a = cumsum(a);

[nr,nc] = size(label);
label = reshape(a(label(:)),nr,nc);

