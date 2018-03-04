%%%%%%%%% test histogram on gray levels %%%%%%%%%%%%%

%load st

nf = 24;np = 7442;nbins = 10;
fvs = colize(ts(:,:,1:nf),Is);

hb.sigs = 0.02*ones(1,nf);
hb.bmins= -0.6*ones(1,nf);
hb.bmaxs= 0.6*ones(1,nf);
hb.nbins= nbins*ones(1,nf);

fh = colize_hist(fvs(1:nf,1:np),hb);

nw = 4;
fhs = colize_histneighb(fh,Is,nw);

%%%%%%%%%%%%%%%%%%
figure(12);
  ct = round(ginput(1));
  idx = (ct(:,1)-1)*size(Is,1) + ct(:,2);

figure(1);
subplot(1,2,1);
imagesc(reshape(fhs(:,idx),nbins,nf))
subplot(1,2,2);
imagesc(reshape(fh(:,idx),nbins,nf))
%%%%%%%%%%

fh = fhs;
fhs = sqrt(fhs);

fh_inner = fhs*fhs';

nv = 30;

[u,d] = eigs(fh_inner,nv); d = diag(d);

figure(3);
for j=1:min(16,nv),
	subplot(4,4,j);
	%plot(u(:,j));
	im(reshape(u(:,j),nbins,nf));
	title(num2str(j));
end

s = 1./sqrt(d);

back_v = (fhs'*u(:,1:nv)).*(ones(np,1)*s(1:nv)');

figure(4);
for j=1:min(16,nv),
	subplot(4,4,j);
	im(reshape(back_v(:,j),size(Is,1),size(Is,2)));axis('off');
	title(num2str(j));
end

figure(1);
semilogy(d,'p-');
%figure(2);imagesc(u);

%%%%%%%%%
figure(12);
  ct = round(ginput(1));
  idx = (ct(:,1)-1)*size(Is,1) + ct(:,2);

figure(5);
for j = 1:min(14,nv),
  subplot(7,2,j);
  nvv = j;
  dist = back_v(idx,1:nvv)*back_v(:,1:nvv)';
  im(reshape(abs(dist).^2,size(Is,1),size(Is,2)));colorbar
  axis('off');title(num2str(nvv));
end




%%%%%%%%%  try the joint x-I histogram bin  %%%%%%%%%%%%%

x = [1:size(Is,1)]'*ones(1,size(Is,2));
x = reshape(x,size(Is,1),size(Is,2));

joint_f(:,:,1) = x;
joint_f(:,:,2) = Is;

fvs = colize(joint_f,Is);

nf = 2;np = 7442;nbins = [5,10];

hb.sigs = [4,0.02].*ones(1,nf);
hb.bmins= [1,0].*ones(1,nf);
hb.bmaxs= [size(Is,1),1].*ones(1,nf);
hb.nbins= nbins.*ones(1,nf);

fh = colize_joint_hist(fvs,hb);
fh = reshape(fh,50,np);

fh_inner = fh*fh';

nv = 30;

[u,d] = eigs(fh_inner,nv); d = diag(d);

figure(3);
for j=1:min(16,nv),
	subplot(4,4,j);
	im(reshape(u(:,j),5,10));axis('off');
	title(num2str(j));
end

s = 1./sqrt(d);

back_v = (fh'*u(:,1:nv)).*(ones(np,1)*s(1:nv)');

figure(4);
for j=1:min(16,nv),
	subplot(4,4,j);
	im(reshape(back_v(:,j),size(Is,1),size(Is,2)));axis('off');
	title(num2str(j));
end


%%%%%%%%  


joint_f = [];

joint_f(:,:,1) = Is;
joint_f(:,:,2) = ts(:,:,1);

fvs = colize(joint_f,Is);

nf = 2;np = 7442;nbins = [10,10];

hb.sigs = [0.02,0.02].*ones(1,nf);
hb.bmins= [0,-0.6].*ones(1,nf);
hb.bmaxs= [1,0.6].*ones(1,nf);
hb.nbins= nbins.*ones(1,nf);

fh = colize_joint_hist(fvs,hb);

fh = reshape(fh,size(fh,1)*size(fh,2),np);

fh_inner = fh*fh';

nv = 30;

[u,d] = eigs(fh_inner,nv); d = diag(d);

figure(3);
for j=1:min(16,nv),
	subplot(4,4,j);
	im(reshape(u(:,j),10,10));axis('off');
	title(num2str(j));
end

s = 1./sqrt(d);

back_v = (fh'*u(:,1:nv)).*(ones(np,1)*s(1:nv)');

figure(4);
for j=1:min(16,nv),
	subplot(4,4,j);
	im(reshape(back_v(:,j),size(Is,1),size(Is,2)));axis('off');
	title(num2str(j));
end


