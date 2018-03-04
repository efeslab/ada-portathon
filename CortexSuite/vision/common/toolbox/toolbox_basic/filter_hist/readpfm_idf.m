function Is = readpfm(filename,ids,nodes)

fid = fopen(filename,'r');

A = fscanf(fid,'%d',2);

Is = zeros(length(ids),nodes);

idt = sort(ids);

idh = 1;

ix = 1;
for j=1:length(ids),

 gap = idt(j) - idh;
 fprintf('%d',gap);

 I = fscanf(fid,'%f',nodes*gap);
 I = fscanf(fid,'%f',nodes);

 Is(find(ids==idt(j)),:) = I(:)';
 fprintf('.');

 idh = idt(j)+1;
end


fclose(fid);
