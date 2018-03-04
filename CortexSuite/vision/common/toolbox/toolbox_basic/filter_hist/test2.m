
%fnameI = '130056';
%fnameI = '134013';
fnameI = '134007';

%%%% flags %%%%%%%%%
read_image = 1;

margin = 10+6;
sigs = [1/sqrt(2),1,sqrt(2),2,2*sqrt(2)];
r =3;
szs = round(3*r*sigs);



%%% image read %%%
if read_image,
  cm = sprintf('I = readpgm(''images/%s.pgm'');',fnameI);
  disp(cm);
  eval(cm);

  Iw = cutoff(I,margin);
  figure(1);imagesc(Iw);axis('image');
end

%%%%  image crop %%%
figure(1);J = imcrop;
figure(2);imagesc(J);axis('image');drawnow;

Jf = filter_output(J,sigs,szs);
margin = 5;
Ja = cutoff(J,margin);Jfa = cutoff(Jf,margin);
figure(2);imagesc(Ja);axis('image');

figure(3);
imagesc(Jfa(:,:,1,3));axis('image');drawnow;

Jfb = reshape(Jfa,size(Jfa,1),size(Jfa,2),size(Jfa,3)*size(Jfa,4));
mag = sum(abs(Jfb),3);

%%%%%% Joint hist. %%%%%%%%%

filter_id = 1;
scale = 1;
h2d = hist_I_f(Ja,Jfa(:,:,filter_id,scale));

figure(4);
imagesc(h2d/sum(sum(h2d)));axis('image');colorbar;colormap(hot);


%%%%%%%%%%  Jointe hist of cropped area %%%%%
%%% block 1
fig_id = 1;
[J3,f3,rect] = crop_im_fil(Ja,Jfa,fig_id);

filter_id = 1;scale = 1;H1 = hist_I_f(J1,f1(:,:,filter_id,scale));


%%% block 2
fig_id = 1;
[J2,f2,rect] = crop_im_fil(Ja,Jfa,fig_id);

filter_id = 1;scale = 1;H2 = hist_I_f(J2,f2(:,:,filter_id,scale));


%%%%% disp result %%%%%

scales = [1:5];
filter_ids = [1:7];

figure(6);disp_hist2d(J2,f2,scales,filter_ids);

figure(4);disp_hist2d(J1,f1,scales,filter_ids);

%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%% smaller window
hw = round(4*sigs(1));

figure(2);%imagesc(Ja);axis('image');
cs = round(ginput(1));

J1 = get_win(Ja,cs,[hw,hw]);Jf1 = get_win5(Jfa,cs,[hw,hw]);
figure(4);imagesc(J1);axis('image');drawnow;
scales = [1:5];filter_ids = [1:7];
figure(9);H2 = disp_hist2d(J1,Jf1,scales,filter_ids);

figure(6); disp_diff(H2,H2o);


%%%%%%  difference in the neighbourhood %%
hw = round(4*sigs(1));
hnb = 3;

B = compute_diff(Ja,Jfa,hw,hnb);


%%%%%%%%%%

if 0,

figure(4);
bint = [-0.15:0.02:0.15];
id = 4;

If = If1;
for j=1:5,
   subplot(5,2,2*(j-1)+1);
   hist(reshape(If(:,:,id,j)./s1,prod(size(If(:,:,id,j))),1),bint);
end

If = If2;
for j=1:5,
   subplot(5,2,2*j);
   hist(reshape(If(:,:,id,j)./s2,prod(size(If(:,:,id,j))),1),bint);
end


%%% make 2d histogram bin
figure(5);
idmax = 5;
filt_id = 4;

for id=1:idmax,

  subplot(idmax,3,(id-1)*3+1);
  h2d1 = hist_I_f(I1a,If1(:,:,filt_id,id),binI,bintex);
  imagesc(h2d1);axis('image')
  subplot(idmax,3,(id-1)*3+2);
  h2d2 = hist_I_f(I2a,If2(:,:,filt_id,id),binI,bintex);
  imagesc(h2d2);axis('image')

  subplot(idmax,3,id*3);
  imagesc(h2d2/sum(sum(h2d2)) + h2d1/sum(sum(h2d1)));axis('image')
  colorbar
end

%%%%%%%%%%%%%%%%%%%%% three types %%%%%%%%
figure(4);
idmax = 5;
filt_id = 2;

width = 4;

for id=1:idmax,

  subplot(idmax,width,(id-1)*width+1);
  h2d1 = hist_I_f(I1a,If1(:,:,filt_id,id),binI,bintex);
  h2d1 = h2d1/sum(sum(h2d1));
  imagesc(h2d1);axis('image');

  subplot(idmax,width,(id-1)*width+2);
  h2d2 = hist_I_f(I2a,If2(:,:,filt_id,id),binI,bintex);
  h2d2 = h2d2/sum(sum(h2d2));
  imagesc(h2d2);axis('image')

  subplot(idmax,width,(id-1)*width+3);
  h2d3 = hist_I_f(I3a,If3(:,:,filt_id,id),binI,bintex);
  h2d3 = h2d3/sum(sum(h2d3));
  imagesc(h2d3);axis('image')

  subplot(idmax,width,id*width);
  imagesc(h2d1+h2d2+h2d3);axis('image')
  colorbar
end


%%%%%%%%%%%% smaller window  %%%%
hw = round(4*sigs(1));

figure(5);%imagesc(I1a);axis('image');
cs = round(ginput(1));

J = get_win(I1a,cs,[hw,hw]);figure(7);imagesc(J);axis('image');

Jf = get_win5(If1,cs,[hw,hw]);
scales = 1:5; nscales = length(scales);
filters = 1:7; nfilters = length(filters);

figure(8);
for j=1:nscales,
   for k=1:nfilters,
       subplot(nscales,nfilters,(j-1)*nfilters+k);
       h2d = hist_I_f(J,Jf(:,:,(j-1)*7+k));h2d = h2d/sum(sum(h2d));
       imagesc(h2d);axis('image');colorbar;axis('off');
   end
end


if 0,

   figure(3);
   cs = ginput(1);

   ws = [15,15];
   J = get_win(I,cs,ws);
   figure(6);imagesc(J);axis('image');

   t1 = get_win5(text_des,cs,ws);

   t1p = abs(t1);
   %t1p = abs(t1);
   %t1p = t1.*(t1>0);

   figure(2);im5(t1p,5,6);

   t1p = reshape(t1p,size(t1p,1)*size(t1p,2),size(t1p,3))';

   t1pm = mean(t1p')';
   t1ps = t1p- t1pm*ones(1,size(t1p,2));

   B = t1ps*t1ps';
   [v,d] = eig(B);d = diag(d);
   figure(4);plot(d,'x-');

   figure(5);
   subplot(2,2,1);vid = 30;plot(reshape(v(:,vid),6,5),'x-');

end

end
