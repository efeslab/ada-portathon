fn = '130042';

fname = sprintf('data/%s_eigvec.pfm',fn);
eigv =  readpfm(fname);
fname = sprintf('data/%s_eigval.pfm',fn);
eigval = readpfm(fname);

fname = sprintf('data/%s_ncutvec.pfm',fn);
ncutv = readpfm(fname);
fname = sprintf('data/%s_ncutval.pfm',fn);
ncutval = readpfm(fname);

%fname = sprintf('images/130038.pgm');
fname = sprintf('images/%s.pgm',fn);
I = readpgm(fname);
cutsz = 20; I = cutoff(I,cutsz);
figure(3);im(I);colormap(gray);

new = 0;

if new,
  fn1 = fn;
  fn = 'test';
  fname = sprintf('data/%s_gcs.pfm',fn);
  gcs = readpfm(fname);

  fname = sprintf('data/%s_gce.pfm',fn);
  gce = readpfm(fname);

  fname = sprintf('data/%s_grs.pfm',fn);
  grs = readpfm(fname);

  fname = sprintf('data/%s_gre.pfm',fn);
  gre = readpfm(fname);

  nr = max(gre(:))+1;
  nc = max(gce(:))+1;

  fn = fn1;

else
 %nr = 49;nc = 30;
 nr = 30;nc = 49;

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
for j=1:9,
  subplot(3,3,j);
  im(reshape(eigv(:,j),nr,nc));colorbar;%axis('off');
  title(sprintf('%3.4e',eigval(j,1)));
end
%cm = sprintf('print -dps eig_%s',fn);disp(cm);eval(cm);



if 0,

fname = 130042;
for j=0:30,
 cm = sprintf('!cp plaatje_data/%d_%d.pfm data/%d_%d.pfm ',fname,j,fname,j);
 disp(cm);eval(cm);
end

%%%%%%%%
fnout = '130042';fn_t = '130042';
cm = sprintf('!cp data/%s_eigval.pfm %s_eigval.pfm',fnout,fn_t);
disp(cm);eval(cm);
cm = sprintf('!cp data/%s_eigvec.pfm %s_eigvec.pfm',fnout,fn_t);
disp(cm);eval(cm);
cm = sprintf('!cp data/%s_ncutvec.pfm %s_ncutvec.pfm',fnout,fn_t);
disp(cm);eval(cm);
cm = sprintf('!cp data/%s_ncutval.pfm %s_ncutval.pfm',fnout,fn_t);
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
  fn = sprintf('data/ncut_%s.pfm',fname);
  ncutv1 = readpfm(fn);
 nr = 30; nc=49;

 figure(1);
 for j=1:min(4,size(ncutv1,2)),
   subplot(2,2,j);
   ims(ncutv1(:,j+1),nr,nc);
 end



%%%%%%%%%%

  id = 0;
  fn = sprintf('data/test_Aa%d.pfm',id);
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
for j=1:nv,subplot(2,nv,j);ims(v(:,j+1),nr,nc);title(sprintf('%3.3e',d(j+1)));end

for j=1:nv,subplot(2,nv,j+nv);ims(eigv(:,j),nr,nc);title(sprintf('%3.3e',eigval(j,1)));end



end
