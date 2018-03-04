function [cut_threshold,max_asso] = find_bst_cut(fn_base,para,threshold,Gmask)

basedir = 'plaatje_data/';
%basedir = './';

fn = sprintf('%sbst_cut.tex',basedir);
write_command(fn,fn_base,para);

fn= sprintf('%sthreshold_%s.pfm',basedir,fn_base);
writepfm(fn,threshold(:));

fn= sprintf('%sGmask_%s.pfm',basedir,fn_base);
writepfm(fn,Gmask(:));

cd plaatje_data
!./find_bestcut
cd /home/barad-dur/vision/malik/jshi/proj/grouping/texture

fn = sprintf('%sbst_asso_%s.pfm',basedir,fn_base);
results = readpfm(fn);
asso = results(1,:);
[max_asso,id] = max(asso);
cut_threshold = threshold(id);

