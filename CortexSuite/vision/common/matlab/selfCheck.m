function ret = selfCheck(in1, path, tol)

r1 = size(in1, 1);
c1 = size(in1, 2);

ret = 1;

file = [path, '/expected.m'];
fd = fopen(file, 'r');

[in2, count] = fscanf(fd, '%d');

if(count ~= (r1*c1) )
    fprintf(1, 'Dimensions mismatch: Expected %d\t Observed %d\n', count, (r1*c1));
    ret = -1;
else
    ret = 1;
    for i=1:(r1*c1)
        if( (abs(in1(i)) - abs(in2(i)) > tol) || (abs(in2(i)) - abs(in1(i))) > tol)
            fprintf(1, 'Checking Error: Index %d\tExpected %d\tObserved %d\n', i, in2(i), in1(i));
            ret = -1;
            break;
        end
    end

end

