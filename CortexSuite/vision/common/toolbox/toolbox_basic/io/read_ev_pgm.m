function [evs,ev_info] = read_ev_pgm(basename,start_id,end_id,neigs)
%
%  evs = read_ev_pgm(basename,start_id,end_id,neigs)
%
%

fname = sprintf('%s_ev_%.2d.%.2d.pgm',basename,start_id,1)
[nr,nc] = peek_pgm_size(fname);

evs = zeros(nr,nc,neigs-1,start_id-end_id+1);
ev_info = zeros(4,neigs-1,start_id-end_id+1);

for j=start_id:end_id,
    for k=1:neigs-1,

        fname = sprintf('%s_ev_%.2d.%.2d.pgm',basename,j,k);
	[I,info] = readpgm_evinfo(fname);

	if (length(info)<4)
	  info = [0;0;0;0];
        end

	evs(:,:,k,j-start_id+1) = I;
        ev_info(:,k,j-start_id+1) = info';
    end
end
