function [x,map] = quant(d1,d2,d3,nbin,ws)

if (~exist('ws')),
  ws = [1,1,1];
end

d1 = d1-min(d1);
d2 = d2-min(d2);
d3 = d3-min(d3);

d1 = d1/max(d1);
d2 = d2/max(d2);
d3 = d3/max(d3);

d1 = d1*ws(1);
d2 = d2*ws(2);
d3 = d3*ws(3);


[x,map] = vmquant(d1,d2,d3,nbin);
