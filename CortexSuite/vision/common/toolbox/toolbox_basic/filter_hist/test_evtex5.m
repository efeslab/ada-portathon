
setup_flag = 0;
cut_window_flag = 0;
run_flag = 0;
other_flag = 0;
test_flag = 1;


%%%%%%%%%%%%%%%%%
if setup_flag == 1,

sigs = [1/sqrt(2),1,sqrt(2),2,2*sqrt(2)];r = 3;szs = round(r*3*sigs);  
szs = szs(length(szs))*ones(1,length(szs));
num_ori = 6;

compute_flag = 0;
if compute_flag,
fnames = [134002,134007,134011,134013,130065,130038,130039,130040,130042,...
          130045,130046,130056,130068];

for j=1:length(fnames),
   fname = sprintf('images/%d.pgm',fnames(j));

   cm = sprintf('!touch /disks/plaatje/scratch/jshi/Fe_%d.mat',fnames(j));
   disp(cm);eval(cm);

   cm = sprintf('!ln -s /disks/plaatje/scratch/jshi/Fe_%d.mat .',fnames(j));
   disp(cm);eval(cm);

   disp(fname);
   I = readpgm(fname);figure(3);im(I);title(num2str(fname));drawnow;
   [text_des,filters] = compute_filter_fft(I,sigs,r,szs,num_ori); 

   cm = sprintf('save Fe_%d text_des filters fname sigs r szs num_ori',fnames(j));
   disp(cm);eval(cm);

   clear text_des filters I
end

end
else
%%%%%%%%%%%%%
  fname = 134013;

  Iname = sprintf('images/%d.pgm',fname);
  I = readpgm(Iname);

  cm = sprintf('load Fe_%d.mat',fname);
  disp(cm);eval(cm);

  figure(1);im(I);


  cutsz =20;
  I = cutoff(I,cutsz);figure(1);im(I);
  text_des = cutoff(text_des,cutsz);

  figure(2);
  for j =1:30,
    subplot(5,6,j);im(text_des(:,:,j));axis('off');
  end

  I1 = I(20:200,70:240);
  T1 = text_des(20:200,70:240,:);

  save st_134013 I1 T1 fname sigs szs r num_ori

end


  
%%%%%%%%%%% normalization %%%%%%%%%%%


I_max = 250;
tex_max = 40;

I1 = min(1,I1/I_max);
T1 = T1/tex_max;
T1 = T1.*(T1<=1) + 1*(T1>1);
T1 = T1.*(T1>=-1) + (-1)*(T1<-1);


end

%%%%%%%%%%

%% for a given sampling rate, get the index for window center
%%

[nr,nc] = size(I1);

hw = 3;
st_sz = 2*hw + 1;

nr_chank = floor(nr/st_sz);
nc_chank = floor(nc/st_sz);

id_chank = [];
for k=1+hw:st_sz:nc-hw,
   for j=1+hw:st_sz:nr-hw,   
	id = j+(k-1)*nr;
 	id_chank = [id_chank,id];
   end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% F1 difference  %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%

fvs = 2*I1(:)'; fvs = fvs -1;

nf = 1;
hb.sigs = 0.02*ones(1,nf);
hb.bmins= -1*ones(1,nf);
hb.bmaxs= 1*ones(1,nf);
hb.nbins= 10*ones(1,nf);
nw = 4;hw =3;

fh = colize_hist(fvs(1:nf,:),hb);
fhs = colize_histnb_s(fh,I1,nw,hw);

fhs = sqrt(fhs);
A = fhs'*fhs;
figure(2);im(A);colorbar;

B = A;

%% display %%%
figure(2);
ct = round(ginput(1));
ct_chank(1) = round((ct(1)-hw-1)/st_sz) + 1;
ct_chank(2) = round((ct(2)-hw-1)/st_sz) + 1;

idx = (ct_chank(:,1)-1)*nr_chank + ct_chank(:,2);

figure(3);im(reshape(A(idx,:),nr_chank,nc_chank));colorbar;

subplot(1,2,1);im(reshape(A1(idx,:),nr_chank,nc_chank));colorbar;
subplot(1,2,2);im(reshape(A2(idx,:),nr_chank,nc_chank));colorbar;


%%%%%%%%%%
save_flag = 0;

fn = 134013;

if save_flag,
  cm = sprintf('save F1_%d fhs hw nw nr_chank nc_chank',fn);
  disp(cm);eval(cm);

end

load_flag = 1;
if load_flag,
  cm = sprintf('load F1_%d',fn);
  disp(cm);eval(cm);

  A=fhs'*fhs;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% F2 difference  %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%

nw = 4;hw =3;

tnf = size(T1,3);
fst = 1;

for j=1:fst:1,
   nf = fst;
   hb.sigs = 0.02*ones(1,nf); hb.bmins= -1*ones(1,nf);
   hb.bmaxs= 1*ones(1,nf);    hb.nbins= 15*ones(1,nf);

   fvs = colize(T1(:,:,j:j+fst-1),I1);
   fh = colize_hist(fvs,hb);
   fhs = colize_histnb_s(fh,I1,nw,hw);
   fhs = sqrt(fhs);

   A = fhs'*fhs;

   cm = sprintf('save F2_%d_%d fhs hw nw nr_chank nc_chank',j,fn);
   disp(cm);eval(cm);
   clear fh;
   
   B = B + A;

   clear A;
   
end


%%%%%% debug + display %%%%%%%%

figure(6);
for j=2:30,
 subplot(5,6,j);
 im(T1(:,:,j-1));axis('off');title(num2str(j-1));
end
subplot(5,6,1);im(I1);axis('off');


figure(6);
B = zeros(size(A));
for j = 1:31,
 %subplot(5,6,j);
 cm = sprintf('load F%d;',j);
 disp(cm);eval(cm);
 
 fhs1 = sqrt(fhs); A = fhs1'*fhs1;
%  im(reshape(A(idx,:),nr_chank,nc_chank));axis('off');title(num2str(j-1));colorbar;
 B = B+A;
end


%%%%%% disp dist. %%%%%%
weight= 5;
A = weight*B+B2;

figure(1);
ct = round(ginput(1));ct_chank(1) = round((ct(1)-hw-1)/st_sz) + 1;
ct_chank(2) = round((ct(2)-hw-1)/st_sz) + 1;
idx = (ct_chank(:,1)-1)*nr_chank + ct_chank(:,2);

figure(2);
im(reshape(A(idx,:),nr_chank,nc_chank));axis('off');colorbar; %title('B');
%figure(3);


save_flag = 0;
if save_flag ,
  B2 = B;
  save tmp B2 nr_chank nc_chank
end

%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%  F3 features  %%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Joint Intensity with filters %%%%


tnf = size(T1,3);

plaatjeon = 1;
if plaatjeon,
     for j=7:tnf,
       cm = sprintf('!touch /disks/plaatje/scratch/jshi/FJ%d.mat',j);
	disp(cm);
	eval(cm);cm = sprintf('!ln -s /disks/plaatje/scratch/jshi/FJ%d.mat .',j);
	disp(cm);eval(cm);
     end
else
     for j=1:1,
	cm = sprintf('!touch ~/store/st/FJ%d.mat',j);	
	disp(cm);eval(cm);
	cm = sprintf('!ln -s ~/store/st/FJ%d.mat .',j);
	disp(cm);eval(cm);
     end
end

for j=7:tnf,
   nf = 2;
   hb.sigs = 0.02*ones(1,nf); hb.bmins= -1*ones(1,nf);
   hb.bmaxs= 1*ones(1,nf);    hb.nbins= 10*ones(1,nf);

   fvs = colize(cat(3,T1(:,:,j),I1));

   fhs = colize_histnb_sf(fvs,I1,hb,nw,hw);
   fhs = sqrt(fhs);
   A = fhs'*fhs;
   cm = sprintf('save FJ%d A fhs',j);
   disp(cm);eval(cm);
  
end

%%%% reload data %%%%%%%%%%%%%%
B = zeros(size(A));

figure(3);

for j=1:tnf,
  cm = sprintf('load FJ%d;',j);
  disp(cm);eval(cm);

  subplot(5,6,j);
  im(reshape(A(idx,:),nr_chank,nc_chank));axis('off');title(num2str(j));

  B = B + A;
end

figure(2);im(reshape(B(idx,:),nr_chank,nc_chank));axis('off');title('B');


%%%%%% disp dist. %%%%%%
figure(12);
ct = round(ginput(1));ct_chank(1) = round((ct(1)-hw-1)/st_sz) + 1;
ct_chank(2) = round((ct(2)-hw-1)/st_sz) + 1;
idx = (ct_chank(:,1)-1)*nr_chank + ct_chank(:,2);

figure(2);
im(reshape(A(idx,:),nr_chank,nc_chank));axis('off');colorbar; 

%%%%%% disp Joint Hist %%%%%%%%%

figure(12);
ct = round(ginput(1));ct_chank(1) = round((ct(1)-hw-1)/st_sz) + 1;
ct_chank(2) = round((ct(2)-hw-1)/st_sz) + 1;
idx = (ct_chank(:,1)-1)*nr_chank + ct_chank(:,2);

figure(1);
im(reshape(fhs(:,idx),10,10));axis('off');colorbar; 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%  F4: Joint filters %%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



tnf = size(T1,3);

nw = 4;hw =3;

for scale=1:5,
  for angle = 1:3,
	cm = sprintf('!touch /disks/plaatje/scratch/jshi/FFJ_%d_%d_%d_%d.mat',angle,angle+3,scale,scale);
	disp(cm);eval(cm);
	cm = sprintf('!ln -s /disks/plaatje/scratch/jshi/FFJ_%d_%d_%d_%d.mat .',angle,angle+3,scale,scale);
	disp(cm);eval(cm);
  end
end


for scale = 1:5,
  for angle = 1:3,
     nf = 2;
     hb.sigs = 0.02*ones(1,nf); hb.bmins= -1*ones(1,nf);
     hb.bmaxs= 1*ones(1,nf);    hb.nbins= 10*ones(1,nf);

     fvs = colize(cat(3,T1(:,:,(scale-1)*6+angle),...
                        T1(:,:,(scale-1)*6+angle+3)));

     fhs = colize_histnb_sf(fvs,I1,hb,nw,hw);
     fhs = sqrt(fhs);
     A = fhs'*fhs;
     cm = sprintf('save FFJ_%d_%d_%d_%d A fhs',angle,angle+3,scale,scale);
     disp(cm);eval(cm);
   end
end


%%%%%%%%%  load results  %%%%%%%%%%%
%B = zeros(size(A));

figure(3);
for scale=1:5,
  for angle = 1:3,
	cm = sprintf('load FFJ_%d_%d_%d_%d.mat',angle,angle+3,scale,scale);
	disp(cm);eval(cm);

        subplot(3,5,scale+(angle-1)*5);
        im(reshape(A(idx,:),nr_chank,nc_chank));
        axis('off');title(sprintf('%d-%d,%d',angle,angle+3,scale));

        %B = B + A;
  end
end




%%%  disp results 

angle = 1;scale = 1;
cm = sprintf('load FFJ_%d_%d_%d_%d.mat',angle,angle+3,scale,scale);
disp(cm);eval(cm);

	

figure(12);
ct = round(ginput(1));ct_chank(1) = round((ct(1)-hw-1)/st_sz) + 1;
ct_chank(2) = round((ct(2)-hw-1)/st_sz) + 1;
idx = (ct_chank(:,1)-1)*nr_chank + ct_chank(:,2);

%figure(1);im(reshape(fhs(:,idx),10,10));axis('off');%colorbar; 
%figure(2);im(reshape(A(idx,:),nr_chank,nc_chank));%axis('off');%title('B');
figure(4);im(reshape(B(idx,:),nr_chank,nc_chank));%axis('off');%title('B');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%% reduction  %%%%%%%%%%%%%%%%%
nv = 50;
[uA,dA] = eigs(A,nv);dA = diag(dA);

figure(4);suAplot(2,1,1);plot(dA,'p-');
subplot(2,1,2);semilogy(dA,'p-');

figure(3);

for j=1:20,
  subplot(4,5,j);
  im(reshape(uA(:,j),nr_chank,nc_chank));axis('off');colorbar;title(num2str(j));
end


%%%%% Ncut without reduction %%%%

[uNu,dNu] = eig_decomp_v5(A,20);

figure(4);subplot(2,1,1);plot(dNu,'p-');
subplot(2,1,2);semilogy(dNu,'p-');

figure(3);
for j=2:6,
  subplot(1,5,j-1);
  im(reshape(-uNu(:,j),nr_chank,nc_chank));axis('off');colorbar;title(num2str(j));
end

%%%%%% Ncut with reduction %%%%%%%%%
nvv = 7;
A1 = uA(:,1:nvv)*uA(:,1:nvv)';


[uN,dN] = eig_decomp_v5(abs(A1),20);

figure(1);subplot(2,1,1);plot(dN,'p-');
subplot(2,1,2);semilogy(dN,'p-');

figure(3);
for j=2:6,
  subplot(1,5,j-1);
  im(reshape(uN(:,j),nr_chank,nc_chank));axis('off');colorbar;title(num2str(j));
end


%%%%%% 




