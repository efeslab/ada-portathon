flag = 2;

if flag ==1,

ws = [50,50];

figure(1);J = get_win(I,ginput(1),ws);
figure(4);imagesc(J);

J = J - mean(mean(reshape(J,prod(size(J)),1)));
X = fftshift(fft2(J));

figure(3);imagesc(abs(X));colorbar
figure(2);mesh(abs(X));

else

fn = '1.pgm';

% spatial gaussian parameter
xscale = 1;

% half size of the neighbourhood 
xnb = 5;

% setting the the HSV gaussian parameter:[h s v]
Iscale = [0.01];

Input_para = [xscale,xnb,Iscale];

% compute the lower half the association matrix
[A,D,Ipara] = compute_A_pgm(fn,Input_para);

nr = Ipara(1);nc = Ipara(2);

B = A+A';
clear A;


% eigen decompostion
options.tol = 1e-4;
num_eig_v = 10;
fprintf('doing eigs ...\n');
[v,d] = eigs(B,num_eig_v,options);

k = 1;imagesc(reshape(v(:,k).*D,nc,nr)');colorbar


end









