function [L1,L2,phi,aniso,pol,con,window_sizes]=wismm2(V);
% [L1,L2,phi,aniso,pol,con,window_sizes]=wismm2(V);
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
   grad_smooth_x=gaussN(Gx,n);
   grad_smooth_y=gaussN(Gy,n);
   grad_smooth_mag=sqrt(grad_smooth_x.^2+grad_smooth_y.^2);
   grad_mag=sqrt(Gx.^2+Gy.^2);
   grad_mag_smooth=gaussN(grad_mag,n);
   pol(:,:,counter)=grad_smooth_mag./(grad_mag_smooth+eps);
   
   % contrast calculation
   con(:,:,counter)=tr;
   counter=counter+1;
end
fprintf(1,'\n')

aniso=1-L2./(L1+eps);

