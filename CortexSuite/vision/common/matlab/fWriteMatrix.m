function fWriteMatrix(input, inpath)

file = [inpath '/expected.m'];
disp(file);
fd = fopen(file, 'w');

[rows, cols] = size(input);

for j=1:rows
    for i=1:cols
        fprintf(fd, '%f\t', input(j,i));
    end
    fprintf(fd, '\n');
end
fclose(fd);
end


