

%case = 1;

read_flag = 1;
compute_flag = 0;
load_flag = 0;
decomp_flag = 0;
hist_flag = 0;

test_real = 0;


if read_flag,
if caseid == 1,
    ifn = 'images/130049.pgm';
elseif caseid == 2,
    ifn = 'images/130055.pgm';
elseif caseid == 3,
    ifn = 'images/130056.pgm';
elseif caseid == 4,
    ifn = 'images/130057.pgm';
elseif caseid == 5,
    ifn = 'images/130060.pgm';
elseif caseid == 6,
    ifn = 'images/130061.pgm';
elseif caseid == 7,
    ifn = 'images/130062.pgm';
elseif caseid == 8,
    ifn = 'images/130065.pgm';
elseif caseid == 9,
    ifn = 'images/130066.pgm';
elseif caseid == 10,
    ifn = 'images/130068.pgm';
elseif caseid == 11,
    ifn = 'images/130070.pgm';
else
    ifn = 'images/130070.pgm';
end

I = readpgm(ifn);
figure(1);
imagesc(I);colormap(gray);drawnow;
axis('tightequal');

end

%%%%% load %%%

if load_flag,
  fn = sprintf('load cresult_%d;',caseid);
  eval(fn);
end


%%%%%%%%%%%%% compute %%%%%%%%%%%
sig = 0.5;
r = 3;
sz = 15;
Iw = cutoff(I,0.5*sz);
figure(1);imagesc(Iw);
axis('image');

if compute_flag,

as = 0:30:150;

Cresult = [];

for j = 1:length(as),
    fprintf('.');
    angle = as(j);

    g = doog2(	sig,r,angle,sz);

    g = g - mean(reshape(g,prod(size(g)),1));

    g = g/sum(sum(abs(g)));

    c = conv2(I,g,'valid');

    Cresult(:,:,j) = c;
end


fprintf('\n');


figure(2);

subplot(2,3,1);
imagesc(Cresult(:,:,1).^2);axis('tightequal');colorbar

subplot(2,3,2);
imagesc(Cresult(:,:,2).^2);axis('tightequal');colorbar

subplot(2,3,3);
imagesc(Cresult(:,:,3).^2);axis('tightequal');colorbar

subplot(2,3,4);
imagesc(Cresult(:,:,4).^2);axis('tightequal');colorbar

subplot(2,3,5);
imagesc(Cresult(:,:,5).^2);axis('tightequal');colorbar

subplot(2,3,6);
imagesc(Cresult(:,:,6).^2);axis('tightequal');colorbar

Cs = [];
Mcs = [];
for j=1:length(as),
    Cs(:,:,j) = reduce(reduce(abs(Cresult(:,:,j))));

    Mcs = [Mcs,max(max(Cs(:,:,j)))];
    
end

ms = max(Mcs);

figure(3);
for j=1:6,
    fn = sprintf('Cs(:,:,%d) = Cs(:,:,%d)/ms;',j,j);
    eval(fn);
    fn = sprintf('subplot(2,3,%d);imagesc(Cs(:,:,%d));',j,j);
    eval(fn);axis('tightequal');colorbar
end

fn = sprintf('save cresult_%d.mat Cresult Cs',caseid);
disp(fn);
eval(fn);

end

%%%%%%%%%%%%%%%%% decomp %%%%%%%%%%%%


if decomp_flag,

%writepnm5('txt_2.pnm',Cs);

%writepnm5('130068.pnm',Cs);


%I_scale = 0.0025;
%X_scale = 3^2;
%[A,D,Ipara] = compute_A_sparmul2(10,I_scale,X_scale);


I_scale = 0.02;
X_scale = 2;
[A,D,Ipara] = compute_A_pnm('130068.pnm',[X_scale,I_scale]);

nr = Ipara(1);nc = Ipara(2);
imagesc(reshape(D,nc,nr)');colorbar;

B = A+A';clear A;

options.tol = 1e-7;

[v,d] = eigs(B,9,options);

figure(4);
k = 1; imagesc(reshape(v(:,k).*D,nc,nr)'); 

end


%%%%  histogram %%%%

%hist_flag = 1;

%figure(1);imagesc(Iw);axis('image');
if hist_flag ==1,


ws = [12,12];

figure(7);

cs = ginput(1);

cs = 10*(cs-1)+w/2;

%cs(1,:) = w+(floor((cs(1,:)-w)/gap)*gap);
%cs(2,:) = w+(floor((cs(2,:)-w)/gap)*gap);

J = get_win(Iw,cs(1,:),ws);
Jbar = get_win5(Cresult,cs(1,:),ws);


figure(2);
subplot(3,3,1);imagesc(J);colorbar
for j=1:6,subplot(3,3,1+j);imagesc(abs(Jbar(:,:,j)));colorbar; end

[hists,bins] = get_hist(J,Jbar);show_hist(hists,bins,4);
cumhists = get_cumhist(hists);show_cumhist(cumhists,bins,6,1,'b-o');

J2 = get_win(Iw,cs(2,:),ws);
Jbar2 = get_win5(Cresult,cs(2,:),ws);

figure(3);
subplot(3,3,1);imagesc(J2);colorbar
for j=1:6,subplot(3,3,1+j);imagesc(abs(Jbar2(:,:,j)));colorbar; end

[hists2,bins2] = get_hist(J2,Jbar2);show_hist(hists2,bins2,5);
cumhists2 = get_cumhist(hists2);show_cumhist(cumhists2,bins2,6,0,'r-*');

diff.inten = max(abs(cumhists.inten-cumhists2.inten));
diff.mag   = max(abs(cumhists.mag-cumhists2.mag));
diff.text  = max(max(abs(cumhists.text-cumhists2.text)));

figure(7);

disp([diff.inten,diff.mag,diff.text]);
maxdiff = max([diff.inten,diff.mag,diff.text]);
disp(1-sigmoid(diff.inten,0.22,0.02));


if 0,
%A = pair_dist_text(Iw,Cresult,15);

r =4;w = 22;gap = 5;sig_x= 20.0;
inpara = [r,w,gap,sig_x,0.16,0.2,0.2];
[Cum,tm] = cAh(Iw,mag,abs(Cresult),inpara);

[Cum,Nb,Nc] = cAh4(Iw,mag,abs(Cresult),inpara);


B = A+ A';clear A;

figure(1);
c = ginput(1);
cx = floor(c(1)/gap);
cy = floor(c(2)/gap);
[cx,cy]
figure(7)
imagesc(reshape(B(cy*Cum(1)+cx,:),Cum(1),Cum(2))');colorbar


cutoff = [0.22,0.2,0.2];
sig_hist = [0.02,0.04,0.05];

inpara2 = [r,5,cutoff,sig_hist];
[A,D] = compute_A_hist3(tm,Cum,inpara2);

B = A+A';clear A;
imagesc(reshape(D,Cum(1),Cum(2))');


[v,d] = eigs(B);


end

end

%%%%%%%%%%%%%  trans_texture %%%%%%%%%%%%
trans_text = 0;


if trans_text,
  figure(1);
  cs = ginput(1);

  ws = [40,40];

  J = get_win(Iw,cs(1,:),ws);
  Jbar = get_win5(Cresult,cs(1,:),ws);
  Jmag = get_win(mag,cs(1,:),ws);

  figure(3);imagesc(J);

  figure(3);
  for j=1:6,
    subplot(2,3,j);imagesc(abs(Jbar(:,:,j)));axis('image');colorbar;
  end

  f= abs(Jbar(40,38,:));
  g= abs(Jbar(40,47,:));

  dot(f,g)/max(dot(f,f),dot(g,g))

  ff = myinterp(f,10);  gg = myinterp(g,10);
  dot(ff,gg)/max(dot(ff,ff),dot(gg,gg))

  cum = mc_corr(ff,gg,[-6,6]);
  max(cum)/max(dot(f,f),dot(g,g))


  center = [40,35];

  f = squeeze(abs(Jbar(center(1),center(2),:)));
  ff = myinterp(f,10);
  mag_ff = dot(ff,ff);
  mag_c = Jmag(center(1),center(2));
  dy = 0;

  cor_cofs = [];
  mags = [];
  for dx = -15:15,
     g = squeeze(abs(Jbar(center(1)+dy,center(2)+dx,:)));
     gg = myinterp(g,10);

     cum = mc_corr(ff,gg,[-6,6]);
     cor_cofs = [cor_cofs,max(cum)/max(mag_ff,dot(gg,gg))];

     mags =[mags,max(mag_c,Jmag(center(1)+dy,center(2)+dx,:))];

  end

  simulation_on =0;

  if simulation_on,

     sz = [161,161]
     SI = zeros(sz);

     for i=2:18:sz(1),
       SI(i:i+2,:) = 1+SI(i:i+2,:);
     end

     imagesc(SI);axis('image');

     tmp1 = mimrotate(SI,90,'nearest','crop');
     tmp2 = mimrotate(SI,45,'nearest','crop');

     ly = round(0.7*sz(1));
     lx = round(0.7*sz(1));
     sy = round(0.16*sz(1));
     sx = round(0.2*sz(2));
     TI = [tmp1(1:ly,1:lx),tmp2(sy+1:sy+ly,sy+1:sy+round(0.4*lx))];

     TI = TI+0.04*randn(size(TI));

     %sig = 1/sqrt(2);r = 3;sz = round(r*3*sig);

     sigs = [1/sqrt(2),1,sqrt(2),2,2*sqrt(2)];r = 3;szs = round(r*3*sigs);
     [text_des,TIw] = compute_filter(TI,sigs,r,szs);
     figure(2);imagesc(TIw);axis('image');

     figure(3);
     im5(abs(text_des),2,3);

     text_des = abs(text_des);

     text_des = T1;

     numband = size(text_des,3); r = 10;
     sig_x = 90; sig_inten = 0.15; sig_tex = 0.01;w_inten = 0.03;
     para = [numband,r,sig_x,sig_inten,sig_tex,w_inten];

     [A,D,Ipara] = compute_A_text(TIw,text_des,para);
     nr = Ipara(1);nc = Ipara(2);
     B = A+A'; clear A;

     figure(2);
     cs = ginput(1);
     cs = round(cs);id = cs(2)*nc+cs(1);

     figure(4);
     imagesc(reshape(B(id,:),nc,nr)');axis('image');colorbar

     [v,d] = eigs(B);
     figure(4);imagesc(reshape(D.*v(:,1),nc,nr)');axis('image');

  end

end

if test_real == 1,
    sigs = [1/sqrt(2),1,sqrt(2),2,2*sqrt(2)];r = 3;szs = round(r*3*sigs);
    text_des = compute_filter(I,sigs,r,szs);

    text_des = abs(text_des);
%save filter_3.mat

    %%%% cutoff margins,
    margin = 6+10;

    Iw = cutoff(I,margin);

    T1= reshape(text_des,size(text_des,1),size(text_des,2),size(text_des,3)*size(text_des,4));
    T1 = cutoff(T1,margin);

    %%%%% reduce resolution

    Iwp = compact(Iw,4);

    T1 = reduce_all(T1);
    T1 = reduce_all(T1);

%    T1 = T1/70;

   % writepnm5('test6_image.pnm',Iwp);writepnm5('test6_filter.pnm',T1);

    numband = size(T1,3); r = 2;
    sig_x = 20; sig_inten = 0.15; sig_tex = 0.01;w_inten = 0.01;
    para = [numband,r,sig_x,sig_inten,sig_tex,w_inten];

    [A,D,Ipara] = compute_A_text(Iwp,T1,para);
    nr = Ipara(1);nc = Ipara(2);
    figure(4);imagesc(reshape(D,nc,nr)');axis('image');
   drawnow;


    numband = 6;
    r = 5;  sig_x = 20.0;
    sig_tex = 0.01; w_inten = 0.01; w = 2;
    para = [numband,r,sig_x,sig_tex,w_inten,w,size(T1,2)];

    [A,D,Ipara] = compute_A_text2(Iw,T1(:,:,1:numband)/70,para);
    nr = Ipara(1);nc = Ipara(2);



    B = A+A'; clear A;


     figure(2);
     cs = ginput(1);
     cs = floor(cs/4)+1;id = cs(2)*nc+cs(1);

     figure(4);
     imagesc(reshape(B(id,:),nc,nr)');axis('image');colorbar

    
end







