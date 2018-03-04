
fn_base = '134035';
ev_id = 4;
para = [12 ev_id nr nc 100];
Gmask = ones(nr,nc);
threshold = find_cutpoint(ncutv(:,ev_id),cmapg,12);
threshold = threshold(1:end-1);

cut_threshold = find_bst_cut(fn_base,para,threshold,Gmask);

figure(8);ims(ncutv(:,ev_id)<cut_threshold,nr,nc);

