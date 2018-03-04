
sw = 3;
gap = 2*sw+1;

nw = 6;

for j=1:20,
   l = max(0,j-1-nw);
%    l = max(0,j-1-2*nw);
   rs(j) = ceil((l-sw)/gap) + 1;
   l = min(20,j-1+nw);
%    l = min(20,j-1);
   re(j) = floor((l-sw)/gap) +1;
end

plot([1:20],rs,'p-',[1:20],re,'rp-')


%%%%%%%%

bin_max = 1.0;
bin_min = -1.0;
num_bin = 30;
sig = 0.2;

data = 0.482;

inc = (bin_max-bin_min)/num_bin;

bs = -100;
be = bin_min+inc;
b = [];

for j=1:num_bin,
  
  b(j) = tmp1(bs,be,data,sig);
  bs = be;
  be= be+inc;
end
plot(b,'p-');



bmin = -1;

inc = 0.2;
a = 0.1;
b = -1250;
ovs = 625;

bs = bmin;
be = bs+inc;

data = -0.482;

for j=1:10,
  tmp = bs-data;
  fs = exp(-(tmp*tmp*ovs));
  ks = b*tmp;

  tmp = be-data;
  fe = exp(-(tmp*tmp*ovs));
  ke = b*tmp;

  bin(j) = fs*(2+a*ks) + fe*(2-a*ke);
  bs = be;
  be = be+inc;
end
