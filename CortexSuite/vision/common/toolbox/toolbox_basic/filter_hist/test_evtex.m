
setup_flag = 0;
cut_window_flag = 0;
run_flag = 0;
other_flag = 0;
test_flag = 1;


%%%%%%%%%%%%%%%%%
if setup_flag == 1,
I = readpgm('images/134035.pgm');

sigs = [1/sqrt(2),1,sqrt(2),2,2*sqrt(2)];r = 3;szs = round(r*3*sigs);  
%[text_des,TIw] = compute_filter(I,sigs,r,szs); 
load filter_134035

text_des = cutoff(text_des,szs(1));

I_max = 255;
tex_max = 75;

TIw = cutoff(I,szs(1));
figure(1);im(TIw);

fts = gen_filters(sigs,r,szs);
Ft  = reshape(fts,size(fts,1)*size(fts,2),size(fts,3)*size(fts,4));
Ft = Ft';
PFt1 = pinv(Ft);

temp1 = zeros(2*szs(end-1)+1,2*szs(end-1)+1);
temp1(szs(end-1)+1,szs(end-1)+1) = 1;
Ft2 = [Ft;temp1(:)'];
PFt2 = pinv(Ft2);


end

%%%%%%%%%%

if cut_window_flag == 1,
wz = [30,30];

figure(1);
ct0 = round(ginput(1))

t0 = cutout(text_des,ct0,wz)/tex_max;
I0 = cutout(TIw,ct0,wz)/I_max;

figure(3);im(I0);colorbar

figure(1);
ct1 = round(ginput(1))

t1 = cutout(text_des,ct1,wz)/tex_max;
I1 = cutout(TIw,ct1,wz)/I_max;

figure(3);im(I1);colorbar

%%%%%%%%%%
ts = cat(2,t0,t1);
Is = [I0,I1];

figure(3);
subplot(2,1,1);im(Is);
subplot(2,1,2);im(ts(:,:,15));

end

%%%%%%

if run_flag == 1,

neigs = 15;

fv1 = colize(t1,I1);
cov1 = fv1*fv1';

[u1,s1] = eigs(cov1,neigs); s1= diag(s1);
figure(4);plot(s1,'p-');

fv0 = colize(t0,I0);
cov0 = fv0*fv0';

[u0,s0] = eigs(cov0,neigs); s0 = diag(s0);
figure(4);hold on; plot(s0,'rp-');

fvs = colize(ts,Is);
covs = fvs*fvs';

[us,ss] = eigs(covs,neigs); ss = diag(ss);
figure(4);plot(ss,'mo-');
hold off

figure(5);
subplot(2,2,1);
im(cov0);colorbar;
subplot(2,2,2);
im(cov1);colorbar;
subplot(2,2,3);
im(covs);colorbar;

%%%%%%%%%%%%%%%%%

ivss = ones(size(ss))./sqrt(ss);
ivs0 = ones(size(s0))./sqrt(s0);
ivs1 = ones(size(s1))./sqrt(s1);


nv = 10;
v1 = fv1'*u1(:,1:nv)*diag(ivs1(1:nv));
v0 = fv0'*u0(:,1:nv)*diag(ivs0(1:nv));
vs = fvs'*us(:,1:nv)*diag(ivss(1:nv));


%v1s = v1(1:50:3721,:);
vss = vs(1:10:7442,:);

if nv == 1,
  mag = vss';
else
  mag = sum(vss'.*vss');
end

tmp1 = vss*vss';
figure(5);im(abs(tmp1));

if 0,
magx = mag'*ones(1,length(mag));
magy = ones(length(mag),1)*mag;
tmp2 = tmp1./(magx+magy);
figure(5);subplot(1,2,2);im(abs(tmp2));colorbar;axis('off');
end


end

%%%%%%%%%%%%%%%%%%%
if other_flag == 1,

%tmp1 = PFt*us(:,1);
%im(reshape(tmp1,sqrt(length(tmp1)),sqrt(length(tmp1))));
PFt = PFt1;


BI0 = back_proj(PFt,u0);
BI1 = back_proj(PFt,u1);
BIs = back_proj(PFt,us);

figure(7);im5(BI0(:,:,1:9),3,3);
figure(8);im5(BI1(:,:,1:9),3,3);
figure(9);im5(BIs(:,:,1:9),3,3);


%%%%%%%%%%
figure(12);
im(Is);

figure(13);
clf
 x1 = vs(1:3721,2);
 y1 = vs(1:3721,3);
 subplot(1,2,1);
 plot(x1,y1,'.')
 axis('image');hold on;
 subplot(1,2,2);
 x2 = vs(3722:end,2);
 y2 = vs(3722:end,3);
 plot(x2,y2,'.')
 axis('image');hold on;


figure(11);
 subplot(1,2,1);hist0 = im_vect([y1,x1]',ones(size(y1)));
 im(hist0);axis('xy');
 subplot(1,2,2);hist1 = im_vect([y2,x2]',ones(size(y1)));
 im(hist1);axis('xy');

end

if test_flag == 1,
figure(12);
  ct = round(ginput(1));
  idx = (ct(1)-1)*size(Is,1) + ct(2);

  cl = 'r';
  figure(13);subplot(1,2,1);
  plot(vs(idx,2),vs(idx,3),[cl,'o']);
  subplot(1,2,2);plot(vs(idx,2),vs(idx,3),[cl,'o']);

  tmp = vs(idx,1:2)*vs(:,1:2)';tmp = reshape(tmp,size(Is,1),size(Is,2));
  figure(14);subplot(3,2,1);
  im(abs(tmp));colorbar
  subplot(3,2,2); im((Is+0.5).*(abs(tmp)>0.2*max(max(abs(tmp)))));

  tmp = vs(idx,1:3)*vs(:,1:3)';tmp = reshape(tmp,size(Is,1),size(Is,2));
  subplot(3,2,3);
  im(abs(tmp));colorbar;
  subplot(3,2,4); im((Is+0.5).*(abs(tmp)>0.2*max(max(abs(tmp)))));

  tmp = vs(idx,1:5)*vs(:,1:5)';
  tmp = reshape(tmp,size(Is,1),size(Is,2));
  subplot(3,2,5);
  im(abs(tmp));colorbar
  subplot(3,2,6); im((Is+0.5).*(abs(tmp)>0.2*max(max(abs(tmp)))));
  
end


%%%%%%%%%%
test_tmp = 0;
if test_tmp,
x = -10:0.02:20;
sig = 4;
d = exp(-(x.^2)/sig);
figure(2);plot(x,d);

ers = [];
for j=0:0.5:10,
 d1 = exp(-(x-j).^2/sig);
 hold on
 plot(x,d1,'r');
 ers = [ers,sum((d1-d).^2)];
end
hold off;

figure(1);plot(ers(end)-ers);






end

%%%%%%%%%%%%%%%%%%%


fvs = colize(ts,Is);

nf = 24;np = 0.5*7442;
hb.sigs = 0.02*ones(1,nf);
hb.bmins= -0.6*ones(1,nf);
hb.bmaxs= 0.6*ones(1,nf);
hb.nbins= 20*ones(1,nf);

%fh = colize_hist(fvs(1:nf,1:10:end),hb);

fh2 = hist_inner(fvs(1:nf,1:np),hb);

[u,d] = eigs(fh2,60); d = diag(d);

%%%%%%%%%%%%
figure(12);
  ct = round(ginput(1));
  idx = (ct(:,1)-1)*size(Is,1) + ct(:,2);

dist = dist_pair(idx,fvs(1:nf,:),hb);
figure(4);
im(reshape(dist,size(Is,1),size(Is,2)));colorbar


%%%%%%%%%
figure(12);
  ct = round(ginput(1));
  idx = (ct(:,1)-1)*size(Is,1) + ct(:,2);

a = colize_hist(fvs(1:nf,idx'),hb);

figure(5);
cl = 'brgm';
for j=1:length(idx);
  plot(a(:,j),cl(j));
  hold on;
end
hold off

%%%%%%%%%%%

%% use chanked feature vectors

chank_size = 1000;
fname = 'st';
histbin_fv_chank(fvs(1:nf,:),hb,chank_size,fname);


covfh2 = hist_in_chank(fvs(1:nf,:),chank_size,hb.nbins(1));
[u2,d2] = eigs(covfh2,60); d2 = diag(d2);

figure(4);
semilogy(d,'p-');

figure(3);imagesc(u);

back_v = backproj_outer_chank(fvs,u,d,chank_size);

back_v2 = backproj_outer_chank2(fvs,u,d,chank_size);


%%%%%%%%%%
figure(2);
for j = 1:16,
  subplot(4,4,j);
  im(reshape(back_v(:,j),size(Is,1),size(Is,2)));
  axis('off');title(num2str(j));
end

binv = linspace(-0.6,0.6,20);

figure(4);
for j=1:16,
  subplot(4,4,j);
  imagesc(reshape(u(:,j),20,24));title(num2str(j));drawnow;
end


figure(6);
for j=1:16,
  subplot(4,4,j);
  plot(binv,(reshape(u(:,j),20,24)));title(num2str(j));drawnow;
end


%%%%%%%%%%
figure(12);
  ct = round(ginput(1));
  idx = (ct(:,1)-1)*size(Is,1) + ct(:,2);

figure(5);
for j = 1:7*2,
  subplot(7,2,j);
  nvv = 2*j;
  dist = back_v(idx,1:nvv)*back_v(:,1:nvv)';
  im(reshape(abs(dist).^2,size(Is,1),size(Is,2)));colorbar
  axis('off');title(num2str(nvv));
end


a = colize_hist(fvs(1:nf,idx'),hb)';

dist_raw = dist_pair_chank(a,fvs,chank_size);
figure(3);im(reshape(dist_raw.^2,size(Is,1),size(Is,2)));



%%%%%%%%%%%%%%
figure(12);
  ct_t3 = round(ginput(5));
  idx_t3 = (ct_t3(:,1)-1)*size(Is,1) + ct_t3(:,2);

a1 = colize_hist(fvs(1:nf,idx_t1'),hb)';
a2 = colize_hist(fvs(1:nf,idx_t2'),hb)';
a3 = colize_hist(fvs(1:nf,idx_t3'),hb)';


%%%%%%%%%%%
figure(1);
for j=1:9,
	subplot(3,3,j);
	hist(back_v(:,j))
end

