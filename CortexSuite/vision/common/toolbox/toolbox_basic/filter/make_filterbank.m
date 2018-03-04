function FB = make_filterbank(num_ori,num_scale,wsz)
%
%  F = make_filterbank(num_ori,num_scale,wsz)
%


% definine filterbank
%num_ori=6;
%num_scale=3;

M1=wsz; % size in pixels
M2=M1;

ori_incr=180/num_ori;
ori_offset=ori_incr/2; % helps with equalizing quantiz. error across filter set

FBdoog1=zeros(M1,M2,num_scale,num_ori);
FBdoog2=zeros(M1,M2,num_scale,num_ori);
FBdog1=zeros(M1,M2,num_scale);
FBdog2=zeros(M1,M2,num_scale);

% elongated filter set
counter = 1;
filter_scale = 1.0;
filter_scale_step = sqrt(2);
 
for m=1:num_scale
   f=dog1(filter_scale,M1);
   FBdog1(:,:,m)=f;
   f=dog2(filter_scale,M1);
   FBdog2(:,:,m)=f;
   counter=counter+1;
   for n=1:num_ori
      % r=12 here is equivalent to Malik's r=3;
      f=doog2(filter_scale,6,ori_offset+(n-1)*ori_incr,M1);
      FBdoog2(:,:,m,n)=f;
      f=doog1(filter_scale,6,ori_offset+(n-1)*ori_incr,M1);
      FBdoog1(:,:,m,n)=f;
   end
   filter_scale = filter_scale * filter_scale_step;
end

FB=cat(3,3*FBdog1,4.15*FBdog2,2*reshape(FBdoog1,M1,M2,num_scale*num_ori),2*reshape(FBdoog2,M1,M2,num_scale*num_ori));
total_num_filt=size(FB,3);

nb = size(FB,3);
for j=1:nb,
  F = FB(:,:,j);
  a = sum(sum(abs(F)));
  FB(:,:,j) = FB(:,:,j)/a;
end


if 0
k=ceil(sqrt(total_num_filt));
for n=1:total_num_filt
   subplot(k,k,n)
   im(FB(:,:,n));
   axis('off')
   drawnow
end
end

