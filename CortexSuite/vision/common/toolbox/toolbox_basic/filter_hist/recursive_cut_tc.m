%function [groups,ids] = recursive_cut(ncutv,fn_base)
%
%
%  function [groups,ids] = recursive_cut(ncutv,threshold,spthresh)
%
%

ncutv= ncutv_o(:,1:4);

fn_base = fn;
%fn_base = '130040';

nvv = size(ncutv_o,2);
nbin = 24;

ids = [];
groups = [];
labels = [];

load cmaps
cmap = cmapg;

j = 1;
done = 0;
np = size(ncutv,1);
nv = size(ncutv,2);

%%%%%% find the cut for the first ncut vector
ev_id = 2;
para = [nvv ev_id nr nc 100];
Gmask = ones(nr,nc);
%threshold = find_cutpoint(ncutv(:,ev_id),cmapg,nbin);threshold = threshold(1:end-1);
threshold = linspace(min(ncutv(:,ev_id)),max(ncutv(:,ev_id)),nbin);
[cut_threshold,max_asso] = find_bst_cut(fn_base,para,threshold,Gmask);
disp(max_asso);

id1 = find(ncutv(:,ev_id)<=cut_threshold);
id2 = find(ncutv(:,ev_id)>cut_threshold);

groups = [groups,id1(:)'];
ids = [ids,length(id1)];

groups = [groups,id2(:)'];
ids = [ids,length(groups)];


for j=3:nv,
        fprintf('j = %d\n',j);
	% expand the current level,
	new_groups = [];
	new_ids = [];

	
	figure(4);ims(ncutv(:,j),nr,nc);title(num2str(j));

	figure(1);clf
	disp_groups(groups,ids,nr,nc);
        drawnow;

	%figure(3);
	% for each leaves,
	mx = max(ncutv(:,j))-min(ncutv(:,j));
	%mx = std(ncutv(:,j));

	base_id =1;
	for k=1:length(ids),
		old_groups = groups(base_id:ids(k));

		v = ncutv(old_groups,j);
		change_v = max(v)-min(v);
                %change_v = std(v);
		n1 = sum(v>(min(v)+0.85*change_v));%n1 = n1/length(old_groups);
                n2 = sum(v<=(min(v)+0.15*change_v));%n2 = n2/length(old_groups);
		disp(sprintf('n1 = %f, n2 = %f',n1,n2));

             figure(2);
             Gmask = zeros(np,1);
             Gmask(old_groups) = Gmask(old_groups)+1;
             drawnow;
             ims(ncutv(:,j).*Gmask,nr,nc);

             disp(sprintf('!!!!!!!!!!!!!RATIO= %f',change_v/mx))

	     %pause;

	     if (((change_v/mx)>0.5) & (n1>10) &(n2>10)),
		
                ev_id = j;

		%threshold = find_cutpoint(ncutv(old_groups,ev_id),cmapg,nbin);threshold = threshold(1:end-1);
		threshold = linspace(min(ncutv(:,ev_id)),max(ncutv(:,ev_id)),nbin);
                para = [nvv ev_id nr nc 100];
		[cut_threshold,max_asso] = find_bst_cut(fn_base,para,threshold,Gmask);

		disp(max_asso);

                if (max_asso>1.2),
		  id1 = find(ncutv(old_groups,ev_id)<=cut_threshold);
		  id2 = find(ncutv(old_groups,ev_id)>cut_threshold);
	
                  figure(5);
		  subplot(1,2,1);maskt= zeros(np,1);maskt(old_groups(id1))=1+maskt(old_groups(id1));ims(maskt,nr,nc);
		  subplot(1,2,2);maskt= zeros(np,1);maskt(old_groups(id2))=1+maskt(old_groups(id2));ims(maskt,nr,nc);
	
	          new_groups = [new_groups,old_groups(id1)];
		  new_ids = [new_ids,length(new_groups)];

	  
		  new_groups = [new_groups,old_groups(id2)];
		  new_ids = [new_ids,length(new_groups)];
                else
                  fprintf(' keep ');
		  new_groups = [new_groups,old_groups];
		  new_ids = [new_ids,length(new_groups)];
                end
	      
              else
		  fprintf(' keep ');
		  new_groups = [new_groups,old_groups];
		  new_ids = [new_ids,length(new_groups)];
              end
	      fprintf('\n');
	      base_id = ids(k) + 1;
 	end

	
	
	groups = new_groups;
	ids = new_ids;

	figure(1);disp_groups(groups,ids,nr,nc);

	fprintf('press return\n');
        pause;
	j= j+1;
end

fprintf('total group = %d \n',length(ids));


