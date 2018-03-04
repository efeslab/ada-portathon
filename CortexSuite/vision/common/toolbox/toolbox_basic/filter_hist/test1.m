
fnameI = '130068';

cm = sprintf('load filter_%s.pgm.mat',fnameI);
disp(cm);
eval(cm);

text_des = abs(text_des);


  %%%% cutoff margins,
margin = 6+10;

Iw = cutoff(I,margin);

T1= reshape(text_des,size(text_des,1),size(text_des,2),size(text_des,3)*size(text_des,4));
T1 = cutoff(T1,margin);

%%%%% reduce resolution



T1 = reduce_all(T1);
T1 = reduce_all(T1);

im5(T1,5,6);

cm = sprintf('writepnm5(''%s_f.pnm'',%s)',fnameI,'T1/70');

%  disp(cm);eval(cm);

nr = size(T1,1);
nc = size(T1,2);

%  D = mreadpfm('D_134011_f.pnm.pfm');

%  figure(3);imagesc(reshape(D,nc,nr)');axis('image');colorbar

if 0,
figure(7);
subplot(3,1,1);hist(reshape(I1,prod(size(I1)),1),binI);
subplot(3,1,2);hist(reshape(I2,prod(size(I2)),1),binI);
subplot(3,1,3);hist(reshape(I3,prod(size(I3)),1),binI);


If1 = filter_output(I1,sigs,szs);
If2 = filter_output(I2,sigs,szs);
If3 = filter_output(I3,sigs,szs);

I1a = cutoff(I1,5); If1 = cutoff(If1,5);
I2a = cutoff(I2,5); If2 = cutoff(If2,5);
I3a = cutoff(I3,5); If3 = cutoff(If3,5);



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
