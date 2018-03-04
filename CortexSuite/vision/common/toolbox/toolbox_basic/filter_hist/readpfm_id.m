function Is = readpfm(filename,ids,nodes)

fid = fopen(filename,'r');

A = fscanf(fid,'%d',2);

Is = zeros(length(ids),nodes);

ix = 1;
for j=1:max(ids),
 I = fscanf(fid,'%f',nodes);
 if (find(ids==j)),
   Is(ix,:) = I(:)';
   ix = ix+1;
   fprintf('.');
  end
end

%I = fscanf(fid,'%f',A(2)*A(1));I = reshape(I,A(1),A(2));

fclose(fid);
