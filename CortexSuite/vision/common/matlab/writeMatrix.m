function writeMatrix(input, inpath)

file = [inpath '/expected.m'];
disp(file);
fd = fopen(file, 'w');

[rows, cols] = size(input);

for j=1:rows
    for i=1:cols
        fprintf(fd, '%d\t', input(j,i)-1);
    end
    fprintf(fd, '\n');
end
fclose(fd);

end


