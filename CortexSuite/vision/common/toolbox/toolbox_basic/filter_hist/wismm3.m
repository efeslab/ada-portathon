function [L1,L2,phi,aniso,pol,con,window_sizes]=wismm3(V);
% [L1,L2,phi,aniso,pol,con,window_sizes]=wismm3(V);
% Calculate windowed image second moment matrices for image V and return
% the following values:
%
% L1 is the larger eigenvalue (lambda_1)
% L2 is the smaller eigenvalue (lambda_2)
% phi is the angle of the 1st eigenvector (phi)
%

[Gx,Gy]=gradient(V);

GGTxx=Gx.^2;
GGTxy=Gx.*Gy;
GGTyy=Gy.^2;

[r,c]=size(V);

min_window_size=3;
max_window_size=3*round(min(r,c)/16);
if (-1)^max_window_size==1
   max_window_size=max_window_size+1;
end
window_step_size=2;

window_sizes=min_window_size:2:max_window_size;
max_count=length(window_sizes);

L1=zeros(r,c,max_count);
L2=zeros(r,c,max_count);
phi=zeros(r,c,max_count);
pol=zeros(r,c,max_count);
con=zeros(r,c,max_count);

fprintf(1,'Integration window size: ');
counter=1;
for n=window_sizes
   fprintf(1,'%d ',n);
   Txx=gaussN(GGTxx,n);
   Txy=gaussN(GGTxy,n);
   Tyy=gaussN(GGTyy,n);
   
   tr=Txx+Tyy;
   V1=0.5*sqrt(tr.^2-4*(Txx.*Tyy-Txy.^2));
   V1=real(V1);
   
   L1(:,:,counter)=0.5*tr+V1;
   L2(:,:,counter)=0.5*tr-V1;
   phi(:,:,counter)=0.5*atan2(2*Txy,Txx-Tyy);

   % do polarity stuff here
   [P,angle_vector]=polarity(Gx,Gy,n);
   quant_bound=angle_vector(2)/2;
   % (quantize angle and pull corresponding polarity out of P)
   % (perhaps use set-theoretic functions for masking out P???)
   for m=1:length(angle_vector);
      a=angle_vector(end-m+1);
      old_pol=pol(:,:,counter);
      Pmask=abs(cos(phi(:,:,counter)-a))>=cos(quant_bound);
      Pmask=Pmask&(old_pol==0); % prevent pileup on quant. boundaries
      pol(:,:,counter)=old_pol+(Pmask.*P(:,:,m));
   end
   
   % contrast calculation
   con(:,:,counter)=tr;
   counter=counter+1;
end
fprintf(1,'\n')

aniso=1-L2./(L1+eps);

