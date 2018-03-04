% script for fft-based filtering

% set up filterbank
make_filterbank
   
% prepare FFT of image for filtering
[N1,N2]=size(V);
I=zeros(size(V)+[M1-1 M2-1]);
I(1:N1,1:N2)=V;
IF=fft2(I);
FI=zeros(N1,N2,total_num_filt);

% apply filters
for n=1:total_num_filt
   disp(n)
   f=rot90(FB(:,:,n),2);
   fF=fft2(f,N1+M1-1,N2+M2-1);
   IfF=IF.*fF;
   If=real(ifft2(IfF));
   If=If(ceil((M1+1)/2):ceil((M1+1)/2)+N1-1,ceil((M2+1)/2):ceil((M2+1)/2)+N2-1);
   FI(:,:,n)=If;
%   im(If)
%   drawnow
end

%%%% end of filtering part; the remainder is for reconstruction & analysis
break


% use pseudoinverse to reconstruct image from filter projections
fbv=reshape(FB,M1*M2,total_num_filt)';
fbi=pinv(fbv);

% find principal components
T=reshape(FI,N1*N2,total_num_filt)';
C=T*T';
[U,S,junk]=svd(C);
s=diag(S);

% synthesize using some eigenvectors
synth=fbi*U;
k=ceil(sqrt(total_num_filt));
for n=1:total_num_filt
   subplot(k,k,n)
   im(reshape(synth(:,n),M1,M2));
   title(num2str(s(n)))
   drawnow
end

% synthesize at a point by clicking on coordinates
figure(1)
im(V)
[x,y]=ginput(1);
x=round(x);
y=round(y);
u=squeeze(FI(y,x,:));
synth=fbi*u;
synth=reshape(synth,M1,M2);
figure(2)
subplot(1,2,1)
im(V)
axis([x-M2/2 x+M2/2 y-M1/2 y+M1/2])
subplot(1,2,2)
im(synth)
title(num2str(max(synth(:))));

figure(3)
plot(u,'o-')

% show pseudoinverse filterbank
if 0
k=ceil(sqrt(total_num_filt));
for n=1:total_num_filt
   subplot(k,k,n)
   im(reshape(fbi(:,n),M1,M2));
   axis('off')
   drawnow
end
end



