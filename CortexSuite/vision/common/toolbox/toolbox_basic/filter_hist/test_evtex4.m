
setup_flag = 0;
cut_window_flag = 0;
run_flag = 0;
other_flag = 0;
test_flag = 1;


%%%%%%%%%%%%%%%%%
if setup_flag == 1,
% = readpgm('images/134035.pgm');

load st3

I_max = 255;
tex_max = 40;

I2 = min(1,I2/I_max);
t2 = t2/tex_max;
t2 = t2.*(t2<=1) + 1*(t2>1);
t2 = t2.*(t2>=-1) + (-1)*(t2<-1);


end

%%%%%%%%%%

%% for a given sampling rate, get the index for window center
%%

[nr,nc] = size(I2);

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

fvs = 2*I2(:)'; fvs = fvs -1;

nf = 1;
hb.sigs = 0.02*ones(1,nf);
hb.bmins= -1*ones(1,nf);
hb.bmaxs= 1*ones(1,nf);
hb.nbins= 10*ones(1,nf);

fh = colize_hist(fvs(1:nf,:),hb);
fhs = colize_histnb_s(fh,I2,nw,hw);

A = fhs'*fhs;
figure(1);im(A);colorbar;

B = A;

%% display %%%
figure(12);
ct = round(ginput(1));
ct_chank(1) = round((ct(1)-hw-1)/st_sz) + 1;
ct_chank(2) = round((ct(2)-hw-1)/st_sz) + 1;

idx = (ct_chank(:,1)-1)*nr_chank + ct_chank(:,2);

figure(3);
im(reshape(A(idx,:),nr_chank,nc_chank));colorbar;



%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% F2 difference  %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%

nw = 4;hw =3;

tnf = size(t2,3);
fst = 1;
r_id = 1;
for j=1:fst:tnf,
   nf = fst;
   hb.sigs = 0.02*ones(1,nf); hb.bmins= -1*ones(1,nf);
   hb.bmaxs= 1*ones(1,nf);    hb.nbins= 10*ones(1,nf);

   fvs = colize(t2(:,:,j:j+fst-1),I2);
   fh = colize_hist(fvs,hb);
   fhs = colize_histnb_s(fh,I2,nw,hw);
   A = fhs'*fhs;
   cm = sprintf('save F%d A fhs',r_id+1);
   disp(cm);eval(cm);
   clear fh;
   
   B = B + A;

   clear A;
   

   r_id = r_id +1;
end


%%%%%% debug + display %%%%%%%%

figure(6);
for j=2:30,
 subplot(5,6,j);
 im(t2(:,:,j-1));axis('off');title(num2str(j-1));
end
subplot(5,6,1);im(I2);axis('off');


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
figure(12);
ct = round(ginput(1));ct_chank(1) = round((ct(1)-hw-1)/st_sz) + 1;
ct_chank(2) = round((ct(2)-hw-1)/st_sz) + 1;

idx = (ct_chank(:,1)-1)*nr_chank + ct_chank(:,2);

figure(2);
im(reshape(B(idx,:),nr_chank,nc_chank));axis('off');title('B');colorbar; 



%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%  F3 features  %%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Joint Intensity with filters %%%%


tnf = size(t2,3);

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

   fvs = colize(cat(3,t2(:,:,j),I2));

   fhs = colize_histnb_sf(fvs,I2,hb,nw,hw);
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



tnf = size(t2,3);

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

     fvs = colize(cat(3,t2(:,:,(scale-1)*6+angle),...
                        t2(:,:,(scale-1)*6+angle+3)));

     fhs = colize_histnb_sf(fvs,I2,hb,nw,hw);
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
[uB,dB] = eigs(B,nv);dB = diag(dB);

figure(1);subplot(2,1,1);plot(dB,'p-');
subplot(2,1,2);semilogy(dB,'p-');

figure(2);

for j=1:20,
  subplot(4,5,j);
  im(reshape(uB(:,j),nr_chank,nc_chank));axis('off');colorbar;title(num2str(j));
end


%%%%% Ncut without reduction %%%%
[uNu,dNu] = eig_decomp_v5(B,20);

figure(1);subplot(2,1,1);plot(dNu,'p-');
subplot(2,1,2);semilogy(dNu,'p-');

figure(2);
for j=2:6,
  subplot(1,5,j-1);
  im(reshape(-uNu(:,j),nr_chank,nc_chank));axis('off');colorbar;title(num2str(j));
end

%%%%%% Ncut with reduction %%%%%%%%%
nvv = 6;
B1 = uB(:,1:nvv)*uB(:,1:nvv)';


[uN,dN] = eig_decomp_v5(abs(B1),20);

figure(1);subplot(2,1,1);plot(dN,'p-');
subplot(2,1,2);semilogy(dN,'p-');

figure(3);
for j=2:6,
  subplot(1,5,j-1);
  im(reshape(uN(:,j),nr_chank,nc_chank));axis('off');colorbar;title(num2str(j));
end


%%%%%% 




