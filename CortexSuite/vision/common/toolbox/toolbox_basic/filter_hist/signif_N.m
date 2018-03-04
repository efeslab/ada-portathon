function a = signif_N(b,N)
%
%
%

Ne = sqrt(N*0.5);

cof = Ne + 0.155 + 0.24/Ne;

a= signif(cof*b);
