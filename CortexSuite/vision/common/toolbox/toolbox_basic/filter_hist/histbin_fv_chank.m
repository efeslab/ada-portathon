function histbin_fv_chank(fvs,hb,chank_size,fname_base)

[nv,np] = size(fvs);

k =1;
for j=1:chank_size:np,
    disp(sprintf('|%d',j));
    fh = colize_hist(fvs(:,j:min(j+chank_size-1,np)),hb);
    fname = sprintf('%s_%d.mat',fname_base,k);
    cm = sprintf('save %s fh hb;',fname);
    disp(cm);
    eval(cm);
    k = k+1;
end
