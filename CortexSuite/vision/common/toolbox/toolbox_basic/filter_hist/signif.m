function a = signif(b)

js = [1:101];


if 0,
d = (-ones(size(js))).^(js-1);
d1 = exp(-2*(js.*js)*b*b);

a = 2*sum(d.*d1);

end

d1 = exp(-2*(js.*js)*b*b);
d2 = 4*(js.*js)*b*b - 1;

a = 2*sum(d1.*d2);

if (b<0.03),a = 1;end



