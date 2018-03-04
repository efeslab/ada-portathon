
im_sz = [40,40];

ob_szh = [6,3];

ob_c  = [15,12];

bg_color = 0.2;

ob_color = 0.8;

mag = 0.2;

I_bg = bg_color + mag*randn(im_sz);

I_obj = ob_color + mag*randn(2*ob_szh+1);


w = 3;

v5 = 1;
Js = [];

if ~v5,
  for j=1:5,
    fc = sprintf('J%d = I_bg;',j);
    eval(fc);

    fc = sprintf('J%d(ob_c(1)-ob_szh(1):ob_c(1)+ob_szh(1),ob_c(2)-ob_szh(2):ob_c(2)+ob_szh(2)) = I_obj;',j);
    eval(fc);

    ob_c = ob_c+[0,2];
  end
else
  nf  = 4;
  for j = 1:nf,

     J = I_bg;
     J(ob_c(1)-ob_szh(1):ob_c(1)+ob_szh(1),ob_c(2)-ob_szh(2):ob_c(2)+ob_szh(2)) = I_obj;

     if (j==1),
       [gy,gx] = grad(J,w);
     end

     ob_c = ob_c+[0,2];

     Jw = cutoff(J,w);
     Js(:,:,j) = Jw;
  end

end

[nr,nc] = size(gx);

for j=1:nf,
  subplot(1,nf,j);
  imagesc(Js(:,:,j));axis('tightequal');
end


writepnm5('test_motion.pnm',Js);
writepnm5('test_motion_gx.pnm',gx);
writepnm5('test_motion_gy.pnm',gy);
%imagesc(J1);colorbar;


inpara = [2,5,0.5,1,0.5];

[A,D,Ipara] = cas('test_motion',inpara);

B= A+ A';
clear A;

%BB = B(1:19^2,19^2+(1:19^2));
%imagesc(BB);

[v,d] = eigs(B);d = diag(d);

k = 2;

figure(1);
%nf = 5;

nr = nr-5;
nc = nc-5;

n = nr* nc;

for j =1:nf,
  subplot(1,nf,j);
  imagesc(reshape(v((j-1)*n+(1:n),k).*D(1:n),nr,nc)');axis('tightequal');
end

%%%%%


figure(3);
T = readpnm('test_motion.pnm');
nf = size(T,3);
for j=1:nf,
  subplot(1,nf,j);
  imagesc(T(:,:,j));axis('tightequal');
end


figure(2);
Gx = readpnm('test_motion_gx.pnm');

[nr,nc] =size(Gx);
n = nr*nc;

imagesc(reshape(B(n+1:2*n,6*nc+7),nc,nr)');colorbar





