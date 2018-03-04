function dg = gauss(sig)
% first derivative of N(sig)
% cutoff after 1% of max

  i = 1;
  max = 0;
  dgi = max;
  dg = [1/ (sqrt(2*pi) * sig) ];
  while dgi >= 0.01*max
    dgi = 1/ (sqrt(2*pi) * sig) * exp(-0.5*i^2/sig^2);
    dg = [dgi dg dgi];
    i = i + 1;
    if dgi > max
      max = dgi;
     end
  end;