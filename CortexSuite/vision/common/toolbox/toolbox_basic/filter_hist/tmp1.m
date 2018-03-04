function d = tmp1(bs,be,data,sig)

sig = sig^2;

if 1,
a = (bs+be)*0.5;
d = (a-bs)*(exp(-(bs-data)^2/sig) + exp(-(a-data)^2/sig)) + ...
    (be-a)*(exp(-(a-data)^2/sig) + exp(-(be-data)^2/sig));
d = d*2/sqrt(pi);
else

a = (be-bs)/2;

h1 = exp(-(bs-data)^2/sig);
h2 = exp(-(be-data)^2/sig);

k1 = -2*(bs-data)/sig;
k2 = -2*(be-data)/sig;

d = a*(h1*(2+2*a*k1) + h2*(2-2*a*k2));
d = d*2/sqrt(pi);

end


