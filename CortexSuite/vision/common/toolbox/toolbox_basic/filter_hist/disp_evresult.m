%fn = '134035';
%fn = '130040';
%fn = '334074';
fn = '130065';

%basedir = 'plaatje_data/olddata/';
%  basedir = 'data/'; nr = 49;nc =30;

basedir = 'plaatje_data/';

fname = sprintf('%s%s_eigvec.pfm',basedir,fn);
eigv =  readpfm(fname);
fname = sprintf('%s%s_eigval.pfm',basedir,fn);
eigval = readpfm(fname);

fname = sprintf('%s%s_ncutvec.pfm',basedir,fn);
ncutv = readpfm(fname);
fname = sprintf('%s%s_ncutval.pfm',basedir,fn);
ncutval = readpfm(fname);

%fname = sprintf('images/130039.pgm');
fname = sprintf('images/%s.pgm',fn);
I = readpgm(fname);
cutsz = 20; I = cutoff(I,cutsz);
figure(3);im(I);colormap(gray);

new = 0;

if ~new,
 
 %nr = 49;nc = 30;
 nr = 30;nc = 49;

%nr = 68;nc = 43;
%nc = 68;nr = 43;

else

  fn1 = fn;
  fn = 'test';
  fname = sprintf('plaatje_data/%s_gcs.pfm',fn);
  gcs = readpfm(fname);

  fname = sprintf('plaatje_data/%s_gce.pfm',fn);
  gce = readpfm(fname);

  fname = sprintf('plaatje_data/%s_grs.pfm',fn);
  grs = readpfm(fname);

  fname = sprintf('plaatje_data/%s_gre.pfm',fn);
  gre = readpfm(fname);

  nr = max(gre(:))+1;
  nc = max(gce(:))+1;

  fn = fn1;

end

figure(6);
for j=1:8,
  subplot(3,3,j);
  im(reshape(ncutv(:,j+1),nr,nc));colorbar
  title(num2str(ncutval(j+1,1)));
end
%cm = sprintf('print -dps ncut_%s',fn);disp(cm);eval(cm);
subplot(3,3,9);im(I);axis('off');

figure(7);clf
for j=1:12,
  subplot(3,4,j);
  im(reshape(eigv(:,j),nr,nc));colorbar;%axis('off');
  title(sprintf('%3.4e',eigval(j,1)));
end
%cm = sprintf('print -dps eig_%s',fn);disp(cm);eval(cm);

%%%%%%%%%%%

ev = eigval(:,1);
figure(5);hold off;clf;subplot(1,2,1);
%semilogy((ev(1:end-1) - ev(2:end))./ev(1:end-1),'x-');grid on;
plot((ev(1:end-1) - ev(2:end))./ev(1:end-1),'x-');grid on;
%semilogy(0.01*ones(size(ev(2:end-1))),'r-');semilogy(0.005*ones(size(ev(2:end-1))),'r-');semilogy(0.0025*ones(size(ev(2:end-1))),'r-');grid on;hold off;
subplot(1,2,2);
%semilogy(ev(1:end-1)-ev(2:end),'p-');grid on;
semilogy((ev(1:end-1) - ev(2:end))/ev(1),'x-');grid on;


if 0,

fname = sprintf('plaatje_data/ncutval_%s.pfm',fn);
nval =  readpfm(fname);
fname = sprintf('plaatje_data/ncutvec_%s.pfm',fn);
nv = readpfm(fname);

figure(2);
nvv = size(nv,2);
for j=1:min(5,nvv-1),
  subplot(1,min(5,nvv-1),j);
  ims(nv(:,j+1),nr,nc);
end


%figure(5);
%subplot(2,2,1);plot(eigval(:,1),'x-');


if 0,

fname = 130039;
for j=0:20,
 cm = sprintf('!cp plaatje_data/%d_%d.pfm plaatje_data/test_%d.pfm ',fname,j,j);
 disp(cm);eval(cm);
end

%%%%%%%%
fnout = 'test';fn_t = '334003';
cm = sprintf('!cp plaatje_data/%s_eigval.pfm %s_eigval.pfm',fnout,fn_t);
disp(cm);eval(cm);
cm = sprintf('!cp plaatje_data/%s_eigvec.pfm %s_eigvec.pfm',fnout,fn_t);
disp(cm);eval(cm);
cm = sprintf('!cp plaatje_data/%s_ncutvec.pfm %s_ncutvec.pfm',fnout,fn_t);
disp(cm);eval(cm);
cm = sprintf('!cp plaatje_data/%s_ncutval.pfm %s_ncutval.pfm',fnout,fn_t);
disp(cm);eval(cm);




end

disp_flag = 0;
if disp_flag,
  [I1,bnr,bnc] = proj_back_id(ncutv(:,2),gcs,gce,grs,gre);
  imvs(I,I1>0.002,bnr,bnc);
end

if 0,

 nv = 3;
 A = eigv(:,1:nv)*eigv(:,1:nv)';
 [v,d] = ncut(abs(A),min(nv,5));

 figure(3);
 for j=1:min(nv,5),
   subplot(2,2,j);
   ims(v(:,j),nr,nc);
 end

end

%%%%%%%%

figure(4);%im(I);colorbar;
hw = 3;st_sz = 2*hw+1;
ct = round(ginput(1));
ct_chank(1) = round((ct(1)-hw-1)/st_sz) + 1;
ct_chank(2) = round((ct(2)-hw-1)/st_sz) + 1;

idx = (ct_chank(:,1)-1)*nr + ct_chank(:,2);

figure(5);im(abs(reshape(A(idx,:),nr,nc)));%colorbar;



  %%%%%

  fname = 'test2';
  fn = sprintf('plaatje_data/ncut_%s.pfm',fname);
  ncutv1 = readpfm(fn);
 nr = 30; nc=49;

 figure(1);
 for j=1:min(4,size(ncutv1,2)),
   subplot(2,2,j);
   ims(ncutv1(:,j+1),nr,nc);
 end



%%%%%%%%%%

  id = 0;
  fn = sprintf('plaatje_data/test_Aa%d.pfm',id);
  disp(sprintf('A = readpfm(%s);',fn));
  A = readpfm(fn);

  cm = sprintf('[v%d,d%d] = eigs(A,12);',id,id);
  disp(cm);eval(cm);

  writepfm('test_eigv0.pfm',v0);
  writepfm('test_eigva0.pfm',diag(d0));




vs = zeros(size(v1,1),size(v1,2),6);
ds = zeros(length(d1),6);

for j=0:5,
  cm = sprintf('vs(:,:,%d) = v%d;',j+1,j);
  disp(cm);eval(cm);
  cm = sprintf('d = diag(d%d);',j);
  disp(cm);eval(cm);
  cm = sprintf('ds(:,%d) = d(:);',j+1);
  disp(cm);eval(cm);


end

%save evsum vs ds

figure(1);nr = 49;nc=30;evid = 3;
for j=1:12,subplot(3,4,j);ims(vs(:,j,evid),nr,nc);end

I = readpgm('images/334039.pgm');I = cutoff(I,20);

As = zeros(6,nr*nc);

figure(3);%im(I);colormap(gray);
hw = 3;st_sz = 2*hw+1;
ct = round(ginput(1));ct_chank(1) = round((ct(1)-hw-1)/st_sz) + 1;ct_chank(2) = round((ct(2)-hw-1)/st_sz) + 1;
idx = (ct_chank(:,1)-1)*nr + ct_chank(:,2);

figure(5);

figure(4);nvs = [6,9,12,12,12,12];
for evid = 1:5,As(evid,:) = squeeze(vs(idx,1:nvs(evid),evid))*squeeze(vs(:,1:nvs(evid),evid))';end
for evid =1:5,subplot(2,3,evid);im(abs(reshape(As(evid,:),nr,nc)));colorbar;end
subplot(2,3,6);ims(sum(abs(As)),nr,nc);colorbar

%%%%%%%%%

%%%%%%  eig of the As over all scales %%

A = zeros(nr*nc,nr*nc);

for evid=1:5,  disp(evid);
  A = A + abs(squeeze(vs(:,1:nvs(evid),evid))*squeeze(vs(:,1:nvs(evid),evid))');
end

[v,d] = eigs(A,12);
figure(1); for j=1:12, subplot(3,4,j);ims(v(:,j),nr,nc);end

[vn,dn] = ncut_b(A,12);
figure(3); for j=1:12, subplot(3,4,j);ims(-vn(:,j),nr,nc);end

nv = 6;
A = abs(eigv(:,1:nv)*eigv(:,1:nv)');
[v,d] = ncut_b(A,nv+1);
figure(1);
nv = 4;
for j=1:nv,subplot(2,nv,j);ims(v(:,j+1),nr,nc);title(sprintf('%3.3e',d(j+1)));end

for j=1:nv,subplot(2,nv,j+nv);ims(eigv(:,j),nr,nc);title(sprintf('%3.3e',eigval(j,1)));end

%%%%%%%%%%%%%

while 1,
figure(3);%im(I);colormap(gray);
hw = 3;st_sz = 2*hw+1;
ct = round(ginput(1));ct_chank(1) = round((ct(1)-hw-1)/st_sz) + 1;ct_chank(2) = round((ct(2)-hw-1)/st_sz) + 1;
idx = (ct_chank(:,1)-1)*nr + ct_chank(:,2);

figure(1);
ims(exp(-(A(idx,:))/(0.02^2)),nr,nc);colorbar
end



%%%%%%%%%%%%%%

figure(3);
hw = 3;st_sz = 2*hw+1;
np = 20;
ct = round(ginput(np));
ct_chank =[];
ct_chank(:,1) = round((ct(:,1)-hw-1)/st_sz) + 1;
ct_chank(:,2) = round((ct(:,2)-hw-1)/st_sz) + 1;
idx = (ct_chank(:,1)-1)*nr + ct_chank(:,2);

%As = readpfm_id('plaatje_data/130040_AX.pfm',idx,2924);
As = readpfm_idf('plaatje_data/tmp/134035_AX3.pfm',idx,nr*nc);

%save dist_data2 As idx ct_chank ct hw nr nc eigv eigval

%load dist_data1a

set(gcf,'DefaultLineLinewidth',5);

minA = min(min(As));
figure(1);clf; hold off;
set(gcf,'DefaultLineLinewidth',2);
for id = 1:np,
subplot(4,5,id);
%image(2.8e-2*((-minA)+reshape(As(id,:),nr,nc)));axis('image');axis('off');hold on
ims(-As(id,:),nr,nc);axis('off');hold on
plot(ct_chank(id,1)+1,ct_chank(id,2)+1,'rx');hold off;
end

figure(1);clf;hold off;
nvv = 6
set(gcf,'DefaultLineLinewidth',1);
for id=1:np,
 At = abs(eigv(idx(id),1:nvv)*eigv(:,1:nvv)');
 subplot(4,5,id);
 %image(2.5e4*reshape(At,nr,nc));axis('image');axis('off');hold on
 ims(At,nr,nc);axis('off');hold on;
 plot(ct_chank(id,1)+1,ct_chank(id,2)+1,'rx');hold off;
end


print_flag =0;
if print_flag,
  fn = '130040';

  figure(4);clf;
  colormap(gray);
  set(gcf,'DefaultLineLinewidth',7);

  for id =1:np,
    %image(2.8e-2*((-minA)+reshape(As(id,:),nr,nc)));axis('image');axis('off');hold on
    ims(-As(id,:),nr,nc);axis('off');
    hold on;plot(ct_chank(id,1)+1,ct_chank(id,2)+1,'rp');hold off;
    cm = sprintf('print -deps dist_x1_%s_%d',fn,id);
    disp(cm);eval(cm);
  end

  nvv = 5;
  set(gcf,'DefaultLineLinewidth',7);
  figure(4);colormap(gray);
  for id=1:np,
    At = abs(eigv(idx(id),1:nvv)*eigv(:,1:nvv)');
    %image(1.5e4*reshape(At,nr,nc));axis('image');axis('off');%hold on
    ims(At,nr,nc);axis('off');%hold on;
    %plot(ct_chank(id,1)+1,ct_chank(id,2)+1,'rp');hold off;
    cm = sprintf('print -deps dist_d_%s_%d',fn,id);
    disp(cm);eval(cm);
  end

  % print eigvects 
  for j=1:size(eigv,2),
    ims(eigv(:,j),nr,nc);axis('off');
    cm = sprintf('print -deps eigv_%s_%d',fn,j);
    disp(cm);eval(cm);
  end
 
  for j=1:size(ncutv,2),
    ims(ncutv(:,j),nr,nc);axis('off');
    cm = sprintf('print -deps ncutv_%s_%d',fn,j);
    disp(cm);eval(cm);
  end


end

basedir ='plaatje_data/newdata/';
fname = sprintf('%s%s_eigvec.pfm',basedir,fn);
eigv =  readpfm(fname);

ix = 1;
figure(5);colormap(gray);clf
for j=1:7,
  for k=[2,3,4,6,9,12];
   subplot(7,6,ix);
   At = abs(eigv(idx(j),1:k)*eigv(:,1:k)');
   ims(At,nr,nc);axis('off');%colorbar;
   if (k==2),
    hold on; plot(ct_chank(j,1),ct_chank(j,2),'rp');hold off;
    title(num2str(j));
   end
   ix = ix+1;
  end
end

figure(4);clf;colormap(gray);
set(gcf,'DefaultLineLinewidth',7);
for j=1:20,
  for k=[2,3,4,6,9,12];
   
   At = abs(eigv(idx(j),1:k)*eigv(:,1:k)');
   ims(At,nr,nc);axis('off');%colorbar;
   if (k==2),
    hold on; plot(ct_chank(j,1),ct_chank(j,2),'rp');hold off;
   end

   cm = sprintf('print -deps dist_scale_65_%d_%d',j,k);
   disp(cm);eval(cm);

  end
end

base_dir = 'plaatje_data/';

% cts are the centers,

wz = [hw,hw];
gap = 2*hw+1;
dist = zeros(size(cts,1),(nr+1)*(nc+1));

for j=1:1:24,
  fn = sprintf('%s134035_%d.pfm',base_dir,j);
  disp(fn);
  F = readpfm(fn);

  dists = compute_Lf(F,cts,wz,nr,nc);
  dist = max(dists,dist);
 
end


figure(4);clf;colormap(gray);
set(gcf,'DefaultLineLinewidth',7);

ids = [8,1,12,5,10,15];

for j=1:6,
 
   d = reshape(dist(j,:),nr+1,nc+1);
   d = d(1:end-1,2:end);
   im(-d);axis('off'); hold on;
   plot(ct_chank(ids(j),1),ct_chank(ids(j),2),'p');
   hold off

   cm = sprintf('print -deps dist_lf_65_%d',j);
   disp(cm);eval(cm);

   pause;
end



end


