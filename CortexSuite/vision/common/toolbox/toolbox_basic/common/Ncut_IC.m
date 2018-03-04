function [v,d] = Ncut_IC(I,nb_radius_IC);
%
% [v,d] = Ncut_IC(I,nb_radius_IC);
%

if nargin<2,
    nb_radius_IC = 5;
end

I = I/max(I(:));

eg_par = [16,2, 21,3]; eg_th = 0;
   
nv = 11; reg_fac = 0.01;

[ex,ey,egx,egy,eg_par,eg_th,emag,ephase] = quadedgep(I,eg_par,eg_th); 
    

nb_radius_IC= 10;
sample_rate = 0.2;
disp('setupW\n');
[w_i,w_j] = cimgnbmap(size(I),nb_radius_IC,sample_rate);
w = affinityic(emag,ephase,w_i,w_j);
disp('computeNcut');
[v,d] = ncut(w,nv,[],reg_fac);

