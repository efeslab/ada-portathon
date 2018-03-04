function [evs,ev_info] = read_ev_pgm2(basename,start_id,end_id,neigs)
%
%  evs = read_ev_pgm(basename,start_id,end_id,neigs)
%
%  read_ev_pgm.m modified by SXY in Feb. 2001.
%  The first eigenvector is also included

fname = sprintf('%s_ev_%.2d.%.2d.pgm',basename,start_id,1)
[nr,nc] = peek_pgm_size(fname);

evs = zeros(nr,nc,neigs,start_id-end_id+1);
ev_info = zeros(4,neigs,start_id-end_id+1);

for j=start_id:end_id,
   
    for k=1:neigs,

        fname = sprintf('%s_ev_%.2d.%.2d.pgm',basename,j,k-1);

  	[I,info] = readpgm_evinfo(fname);

        if (length(info)<4)
	         info = [0;0;0;0];
        end

    	evs(:,:,k,j-start_id+1) = I;
        ev_info(:,k,j-start_id+1) = info';
    end
end
