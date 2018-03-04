% function [xs,ys,gx,gy,par,threshold,mag,mage,g,FIe,FIo,mago] = quadedgep(I,par,threshold);
% Input:
%    I = image
%    par = vector for 4 parameters
%      [number of filter orientations, number of scale, filter size, elongation]
%      To use default values, put 0.
%    threshold = threshold on edge strength
% Output:
%    [x,y,gx,gy] = locations and gradients of an ordered list of edgels
%       x,y could be horizontal or vertical or 45 between pixel sites
%       but it is guaranteed that there [floor(y) + (floor(x)-1)*nr] 
%       is ordered and unique.  In other words, each edgel has a unique pixel id.
%    par = actual par used
%    threshold = actual threshold used
%    mag = edge magnitude
%    mage = phase map
%    g = gradient map at each pixel
%    [FIe,FIo] = odd and even filter outputs
%    mago = odd filter output of optimum orientation

% Stella X. Yu, 2001

% This is the multi scale version of the filtering
% For the moment the parameters are defined by default. See line 34


function [x,y,gx,gy,par,threshold,mag_s,mage,g,FIe,FIo,mago] = quadedgep2(I,par,data,threshold);


if nargin<4 | isempty(threshold),
    threshold = 0.1;
end

[r,c] = size(I);
def_par = [4,30,3];

display_on = 1;

% take care of parameters, any missing value is substituted by a default value
if nargin<2 | isempty(par),
   par = def_par;
end
% par(end+1:4)=0;
% par = par(:);
% j = (par>0);
% have_value = [ j, 1-j ];
% j = 1; n_filter = have_value(j,:) * [par(j); def_par(j)];
% j = 2; n_scale  = have_value(j,:) * [par(j); def_par(j)];
% j = 3; winsz    = have_value(j,:) * [par(j); def_par(j)];
% j = 4; enlong   = have_value(j,:) * [par(j); def_par(j)];

n_ori = par(1);      %if it doesn't work, par<-def_par

winsz = par(2);
enlong = par(3);

% always make filter size an odd number so that the results will not be skewed
j = winsz/2;
if not(j > fix(j) + 0.1),
    winsz = winsz + 1;
end

% filter the image with quadrature filters 
if (isempty(data.W.scales))
        error ('no scales entered');
end

n_scale=length(data.W.scales);
filter_scales=data.W.scales;
%     
% if strcmp(data.dataWpp.mode,'multiscale')
%     n_scale=size((data.dataWpp.scales),2);
%     filter_scales=data.dataWpp.scales;
% else
%     filter_scales=data.dataWpp.scales(1);
%     n_scale=1;
% end
% if n_scale>0&&strcmp(data.dataWpp.mode,'multiscale')
%     if (~isempty(data.dataWpp.scales))
%         filter_scales=data.dataWpp.scales;
%     else
%         filter_scales=zeros(1,n_scale);
%         
%         for i=1:n_scale,
%         filter_scales(i)=(sqrt(2))^(i-1);
%         end
%         data.dataWpp.scales=filter_scales;
%     end
% else filter_scale=1;
%     data.dataWpp.scales=filter_scales;
% end
% 
% %%%%%%% juste pour que ca tourne
% if ~strcmp(data.dataWpp.mode,'multiscale')
%     filter_scales=data.dataWpp.scales(1);
%     n_scale=4;
% end
% %%%%%%%%%%%%

FBo = make_filterbank_odd2(n_ori,filter_scales,winsz,enlong);
FBe = make_filterbank_even2(n_ori,filter_scales,winsz,enlong);
n = ceil(winsz/2);
f = [fliplr(I(:,2:n+1)), I, fliplr(I(:,c-n:c-1))];
f = [flipud(f(2:n+1,:)); f; flipud(f(r-n:r-1,:))];
FIo = fft_filt_2(f,FBo,1); 
FIo = FIo(n+[1:r],n+[1:c],:);
FIe = fft_filt_2(f,FBe,1);
FIe = FIe(n+[1:r],n+[1:c],:);

% compute the orientation energy and recover a smooth edge map
% pick up the maximum energy across scale and orientation
% even filter's output: as it is the second derivative, zero cross localize the edge
% odd filter's output: orientation

[nr,nc,nb] = size(FIe);

FIe = reshape(FIe, nr,nc,n_ori,length(filter_scales));
FIo = reshape(FIo, nr,nc,n_ori,length(filter_scales));

mag_s = zeros(nr,nc,n_scale);
mag_a = zeros(nr,nc,n_ori);

mage = zeros(nr,nc,n_scale);
mago = zeros(nr,nc,n_scale);
mage = zeros(nr,nc,n_scale);
mago = zeros(nr,nc,n_scale);



for i = 1:n_scale,
    mag_s(:,:,i) = sqrt(sum(FIo(:,:,:,i).^2,3)+sum(FIe(:,:,:,i).^2,3));
    mag_a = sqrt(FIo(:,:,:,i).^2+FIe(:,:,:,i).^2);
    [tmp,max_id] = max(mag_a,[],3);
 
    base_size = nr * nc;
    id = [1:base_size]';
    mage(:,:,i) = reshape(FIe(id+(max_id(:)-1)*base_size+(i-1)*base_size*n_ori),[nr,nc]);
    mago(:,:,i) = reshape(FIo(id+(max_id(:)-1)*base_size+(i-1)*base_size*n_ori),[nr,nc]);
    
    mage(:,:,i) = (mage(:,:,i)>0) - (mage(:,:,i)<0);

    if display_on, 
    ori_incr=pi/n_ori; % to convert jshi's coords to conventional image xy
    ori_offset=ori_incr/2;
    theta = ori_offset+([1:n_ori]-1)*ori_incr; % orientation detectors
    % [gx,gy] are image gradient in image xy coords, winner take all
    
    ori = theta(max_id);
    ori = ori .* (mago(:,:,i)>0) + (ori + pi).*(mago(:,:,i)<0);
    gy{i} = mag_s(:,:,i) .* cos(ori);
    gx{i} = -mag_s(:,:,i) .* sin(ori);
    g = cat(3,gx{i},gy{i});

    % phase map: edges are where the phase changes
    mag_th = max(max(mag_s(:,:,i))) * threshold;
    eg = (mag_s(:,:,i)>mag_th);
    h = eg & [(mage(2:r,:,i) ~= mage(1:r-1,:,i)); zeros(1,nc)];
    v = eg & [(mage(:,2:c,i) ~= mage(:,1:c-1,i)), zeros(nr,1)];
    [y{i},x{i}] = find(h | v);
    k = y{i} + (x{i}-1) * nr;
    h = h(k);
    v = v(k);
    y{i} = y{i} + h * 0.5; % i
    x{i} = x{i} + v * 0.5; % j
    t = h + v * nr;
    gx{i} = g(k) + g(k+t);
    k = k + (nr * nc);
    gy{i} = g(k) + g(k+t);
    
%     figure(1);
%     clf;
%     imagesc(I);colormap(gray);
%     hold on;
%     quiver(x,y,gx,gy); hold off;
%     title(sprintf('scale = %d, press return',i));
    
   % pause;
    0;
else
    x = [];
    y = [];
    gx = [];
    gy =[];
     g= [];
 end
end


