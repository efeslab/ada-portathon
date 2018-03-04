function [evs,ev_info] = read_ev_pgm(basename,start_id,end_id,neigs)
%
%  evs = read_ev_pgm(basename,start_id,end_id,neigs)
%
%

fname = sprintf('%s_ev_%.2d.%.2d.pgm',basename,start_id,1);
[nr,nc] = peek_pgm_size(fname);

evs = zeros(nr,nc,neigs-1,start_id-end_id+1);
ev_info = zeros(4,neigs-1,start_id-end_id+1);

for j=start_id:end_id,
    for k=1:neigs,

        fname = sprintf('%s_ev_%.2d.%.2d.pgm',basename,j,k-1);
	[I,info] = readpgm_evinfo(fname);

	evs(:,:,k,j-start_id+1) = I;
        ev_info(:,k,j-start_id+1) = info';
    end
end

evs = squeeze(evs);

for j=1:neigs,
      evs(:,:,j) = (evs(:,:,j)/ev_info(3,j)) +ev_info(1,j);
      %evs(:,:,j) = evs(:,:,j)/norm(reshape(evs(:,:,j),nr*nc,1));
end
    
