function NMS = max_supress2(data,ismax);
%
%   NMS = max_supress(data,ismax);
%
%      data: [nr,nc,nfilter,nscale]
%               of filter mag. map
%      ismax: 1 local max, 0 local min
%

[nr,nc,nfilter,nscale] = size(data);

% set up the orthognal neighbourhood for each oriented filter
if nfilter == 6,
  nbr_template=[1 1 1 0 -1 -1
	        0 1 1 1  1  1];
else
  nbr_template=[1 0 ; 
                0 1];
end

%% for each scale, compute the dominate filter response
canny_dir_I = zeros(nr,nc,nscale);

for m = 1:nscale,
   [max_Ori_resp_I,Ori_sca_I] = max(data(:,:,:,m),[],3);
   canny_dir_I(:,:,m) = Ori_sca_I;
end

max_Ori_resp_small = max_Ori_resp_I(2:end-1,2:end-1);
canny_dir = canny_dir_I(2:end-1,2:end-1);

%% 

NMS = zeros(nr,nc,nscale);


for m = 1:nscale,
 
  [x,y] = meshgrid(2:nc-1,2:nr-1);
  xid = x(:)+nbr_template(2,canny_dir(:))';
  yid = y(:)+nbr_template(1,canny_dir(:))';
  id1 = (xid-1)*nr+yid;

  xid = x(:)-nbr_template(2,canny_dir(:))';
  yid = y(:)-nbr_template(1,canny_dir(:))';
  id2 = (xid-1)*nr+yid;
  if ismax,
    a = (max_Ori_resp_small(:)>max_Ori_resp_I(id1(:))) .* (max_Ori_resp_small(:)>max_Ori_resp_I(id2(:)));
    NMS(2:end-1,2:end-1,m) = reshape(a,nr-2,nc-2);
    NMS(:,:,m) = NMS(:,:,m).*max_Ori_resp_I;
  else
    a = (max_Ori_resp_small(:)<max_Ori_resp_I(id1(:))) .* (max_Ori_resp_small(:)<max_Ori_resp_I(id2(:)));
    NMS(2:end-1,2:end-1,m) = reshape(a,nr-2,nc-2);
  end
  
end

 

