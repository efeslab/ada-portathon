function [v,d,D,Ipara] = eigs_decomp(fn,num_eigs)
%
%   function [v,d,D,Ipara] = eigs_decomp(fn,num_eigs)
%

%fn = '2.ppm';
fn = 'images/130049.pgm';


% spatial gaussian parameter
xscale = 3;

% half size of the neighbourhood 
xnb = 6;

% setting the the HSV gaussian parameter:[h s v]
Iscale = [0.008,0.01,0.01];

Input_para = [xscale,xnb,Iscale];

% compute the lower half the association matrix
[A,D,Ipara] = compute_A_ppm(fn,Input_para);

B = A+A';
clear A;

% eigen decompostion
options.tol = 1e-7;
num_eig_v = 4;
fprintf('doing eigs ...\n');
[v,d] = eigs(B,num_eig_v,options);

d = diag(d);

% to display the final result

%nr = Ipara(1);nc = Ipara(2);
%k = 1;imagesc(reshape(v(:,k).*D,nc,nr)');colorbar

