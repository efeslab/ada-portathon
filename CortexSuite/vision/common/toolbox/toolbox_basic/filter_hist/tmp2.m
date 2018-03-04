function d = tmp2(bs,be,data,sig)

sig = sig^2;


a = (be-bs)/2;

h1 = exp(-(bs-data)^2/sig);
h2 = exp(-(be-data)^2/sig);

k1 = -2*(bs-data)/sig;
k2 = -2*(be-data)/sig;

d = (h1*(2+2*a*k1) + h2*(2-2*a*k2));
%d = a*d*2/sqrt(pi);


