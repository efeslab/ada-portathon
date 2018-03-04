% function rec = jshincutdefpar;
% default parameter setting for Jianbo Shi's NCut C codes

% Stella X. Yu, 2000.

function rec = jshincutdefpar;

rec.fname_base =     '240018s'; 
rec.fname_ext =          'ppm'; 
rec.num_eigvecs =          15;  
rec.spatial_neighborhood_x=20;  
rec.sigma_x=               10;  
rec.sig_I=                 -0.16;
rec.sig_IC=                0.01;
rec.hr=                    2;
rec.eig_blk_sze=           3;
rec.power_D=               1;
rec.offset =               0.0;
rec.sig_filter =           1.0;
rec.elong_filter =         3.0;
