function fid = readFile(path)

file = fopen(path, 'r');

full = fscanf(file,'%f');
elapsed = zeros(1,2);

rows = full(1);
cols = full(2);
fid = zeros(rows, cols);

k = 3;
for i=1:rows
    for j =1:cols
        fid(i,j) = full(k);
        k = k+1;
    end
end
fclose(file);

end

