function w = gen_w(a)
%

if (nargin == 0),
  a = 0.4;
end

w(3) = a;
w(1) = 1/4 - a/2;
w(5) = 1/4 - a/2;
w(2) = 1/4;
w(4) = 1/4;
