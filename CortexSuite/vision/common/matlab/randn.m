%! _randn_f2_i1i1

function retRand = randn(m,n)

retRand = ones(m,n);

for i=1:m
    for j=1:n
        w = 10;
        while(w>=1.0)
            x1 = 2.0 * rand(1,1) - 1.0;
            x2 = 2.0 * rand(1,1) - 1.0;
            w = x1*x1 + x2*x2;
        end
        w = sqrt((-2.0*log(w))/w);
        retRand(i,j) = x1*w;
    end
end




