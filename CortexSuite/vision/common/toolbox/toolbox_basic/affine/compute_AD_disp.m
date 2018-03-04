function [A,D,mask] =...
compute_AD_disp(img_i,img_j,center_i,center_j,window_size_h,num_iter,w,fig_disp,num_trans,Dest,mask)
%
% function [A,D,mask] = ...
%     compute_AD_disp(img_i,img_j,center_i,center_j,window_size_h,num_iter,w,
%                fig_disp,mask,num_trans)
%  
%  Computing affine transform for matching to image patches.  Display results
%  as program runs.
%
%  A: Affine motion;
%  D: Displacement;
%  
%
%  img_i, img_j: the two image(in full size);
%  center_i, center_j:  the centers of the feature in two images;
%  window_size_h: half size of the feature window;
%  num_iter: 	number of iterations;
%  w: 		parameter used in "grad.m" for computing gaussians used for
%      		gradient estimation;
%  fig_disp:	figure for display;
%
%  num_trans:   OPTIONAL, number of translation iteration;
%  mask:  	OPTIONAL, if some area of the square shaped feature window should
%         		  be weighted less;
%


%
%    Jianbo Shi
%

if ~exist('mask'),
   mask = ones(2*window_size_h+1)';
end

if ~exist('Dest'),
  Dest = [0,0];
end

% set the default num_trans
if ~exist('num_trans'),
   num_trans= 3;
end

% normalize image intensity to the range of 0.0-1.0
img_i = norm_inten(img_i);
img_j = norm_inten(img_j);

window_size = 2*window_size_h + 1;
I = carve_it(img_i,center_i,window_size_h);
J = carve_it(img_j,center_j,window_size_h);

% init. step
D_computed = Dest;
A_computed = eye(2);
J_computed = compute_J(A_computed,D_computed,img_i,center_i,window_size_h);



figure(fig_disp);subplot(1,3,1);imagesc(I);colormap(gray);axis('image');
subplot(1,3,3);imagesc(J);axis('image');
drawnow;

sig = 0.1;

records = zeros(num_iter,6);
errs = zeros(1,num_iter);

k = 1;
% iteration
while k <= num_iter,
  [A,D] = iter_AD(J_computed,J,mask,w,k,num_trans);

  A_computed = A*A_computed;
  D_computed = (A*D_computed')' + D;

  % compute the warped image
  J_computed = compute_J(A_computed,D_computed,img_i,center_i,window_size_h);

  % compute the SSD error
  errs(k) = sqrt(sum(sum((mask.*(J_computed-J)).^2)))/prod(size(J))

  % update the mask, discounting possible occlusion region
  if (k>num_trans+1),
    mask = exp(-abs(J_computed-J)/sig);
  end

  % record the A and D
  records(k,:) = [reshape(A_computed,1,4),reshape(D_computed,1,2)];

  figure(fig_disp);subplot(1,3,2);imagesc(J_computed);axis('image');
  title(sprintf('iter:%d: dx=%3.3f, dy = %3.3f',k,D_computed(1),D_computed(2)));drawnow; 

  k = k+1;
end  

[tmp,id] = min(errs);
A = reshape(records(id,1:4),2,2);
D = reshape(records(id,5:6),1,2);

J_computed = compute_J(A,D,img_i,center_i,window_size_h);
mask = exp(-abs(J_computed-J)/sig);
