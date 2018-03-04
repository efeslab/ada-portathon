function [L1,L2,phi,Txx,Txy,Tyy]=wismm(X,N);
% [L1,L2,phi,T11,T12,T22]=wismm(X,N);
% Calculate windowed image second moment matrices for image X and return
% the following values:
%
% L1 is the larger eigenvalue (lambda_1)
% L2 is the smaller eigenvalue (lambda_2)
% phi is the angle of the 1st eigenvector (phi)

[G1,G2]=gradient(X);

GGTxx=G1.^2;
GGTxy=G1.*G2;
GGTyy=G2.^2;

Txx=gaussN(GGTxx,N);
Txy=gaussN(GGTxy,N);
Tyy=gaussN(GGTyy,N);

tr=Txx+Tyy;
V1=0.5*sqrt(tr.^2-4*(Txx.*Tyy-Txy.^2));

L1=real(0.5*tr+V1);
L2=real(0.5*tr-V1);
phi=0.5*atan2(2*Txy,Txx-Tyy);

