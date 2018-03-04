function out = randnWrapper(m, n)

out = ones(m,n);
temp = randWrapper(m,n);

for i=1:m
    for j=1:n
        w = temp(i,j);
        x1 = 1;
        %w = sqrt((-2.0*log(w))/w);
        w = ((-2.0*log(w))/w);
        out(i,j) = x1*w;
    end
end

end

