
%%%%%%%%% test histogram on gray levels %%%%%%%%%%%%%

%load st
%fvs = colize(Is,Is);

nf = 1;np = 7442;nbins = 10;

hb.sigs = 0.02*ones(1,nf);
hb.bmins= 0*ones(1,nf);
hb.bmaxs= 1*ones(1,nf);
hb.nbins= nbins*ones(1,nf);

fh = colize_hist(fvs(1:nf,1:np),hb);

fh_inner = fh*fh';

nv = nbins-1;

[u,d] = eigs(fh_inner,nv); d = diag(d);

figure(6);
for j=1:nv,
	subplot(4,4,j);
	plot(u(:,j));
	title(num2str(j));
end

s = 1./sqrt(d);

back_v = (fh'*u(:,1:nv)).*(ones(np,1)*s(1:nv)');

figure(7);
for j=1:nv,
	subplot(4,4,j);
	im(reshape(back_v(:,j),size(Is,1),size(Is,2)));axis('off');
	title(num2str(j));
end

figure(1);
plot(d,'p-');
figure(2);
im(u);


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


