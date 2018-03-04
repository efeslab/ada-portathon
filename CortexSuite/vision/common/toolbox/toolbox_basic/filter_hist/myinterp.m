function y = myinterp(d,rate)
%


if (size(d,1)>1),
  d = [d;d(1)];
else 
  d = [d,d(1)];
end

lgn = length(d);

x = 1:lgn;
xx = linspace(1,lgn,rate*lgn);

y = interp1(x,d,xx,'linear');

y = y(1:(length(y)-1));
