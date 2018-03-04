function [v,d] = Ncut_IC_m(I,mask,nb_radius_IC,sig_IC);
%
% [v,d] = Ncut_IC_m(I,mask,nb_radius_IC,sig_IC);
%

if nargin<2,
    mask = ones(size(I));
end

if nargin<3,
    nb_radius_IC = 10;
end

if nargin<4,
    sig_IC = 0.03;
end

%%% normalize the image
I = I/max(I(:));

%%% edge detecting parameter, [num_ori, sig, win_size, enlongation factor]
eg_par = [6,2, 21,3]; eg_th = 0.01;
   
%% number of eigenvectors+ regulization factors
nv = 10; reg_fac = 0.0;

%% compute the edge response
[nr,nc,nb] = size(I);
emag = zeros(nr,nc);
ephase = zeros(nr,nc);
for j=1:nb,
    [ex,ey,egx,egy,eg_par,eg_th,emag1,ephase1] = quadedgep(I(:,:,j),eg_par,eg_th); 
    mask = emag1>emag;
    ephase = ephase+ mask.*ephase1;
    emag = emag + mask.*emag1;
end


%%% setup Wij connection pattern
sample_rate = 0.1;
[w_i,w_j] = cimgnbmap(size(I),nb_radius_IC,sample_rate);

%%% compute Wij with IC
emag = mask.*emag;
w = affinityic(emag,ephase,w_i,w_j,sig_IC);

%show_dist_w(I,w);
%%% running Ncut
[v,d] = ncut(w,nv);

v = reshape(v,size(I,1),size(I,2),size(v,2));
