function J = gauss_lowpass(I,a)

if (nargin < 2),
  a = 0.4;
end

w = gen_w(a);

J = conv2(conv2(I,w,'same'),w','same');
