function [centers,label,post,d2]=find_textons(FIw,ncenters,centers_in,n_iter);
% [centers,label,post,d2]=find_textons(FIw,ncenters,centers_in,n_iter);
% 
% find textons using kmeans for windowed portion FIw of filtered image 
%
% to start with centers pulled randomly from image, set centers_in=[]

% define number of textons
%ncenters=25;

[N1,N2,N3]=size(FIw);
% reshape filtered image stack into a long array of feature vectors
fv=reshape(FIw,N1*N2,N3);
% (each row is a feature vector)

%centers=.01^2*randn(ncenters,N3);
% take centers randomly from within image
if isempty(centers_in)
   rndnum=1+floor(N1*N2*rand(1,ncenters));
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

% reshuffle the centers so that the one closest to the origin
% (featureless) comes last
norms=sum(centers.^2,2);
[sortval,sortind]=sort(-norms);
centers=centers(sortind,:);
d2=reshape(d2,N1,N2,ncenters);
post=reshape(post,N1,N2,ncenters);
d2=d2(:,:,sortind);
post=post(:,:,sortind);


% retrieve cluster number assigned to each feature vector
[minval,label]=min(d2,[],3);

