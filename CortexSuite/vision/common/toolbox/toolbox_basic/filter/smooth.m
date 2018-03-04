% smooth an image
% coordinates (r, c) follow matrix convention;
% the gaussian is truncated at x = +- tail, and there are samples samples
% inbetween, where samples = hsamples * 2 + 1

function g = smooth(image, hsamples)

tail=4;
samples = hsamples * 2 + 1;

x = linspace(-tail, tail, samples);
gauss = exp(-x.^2);
%s = sum(gauss)/length(x);gauss = gauss-s;
gauss = gauss/sum(abs(gauss));

n = gauss * ones(samples,1);
gauss = gauss/n;


g = conv2(conv2(image, gauss,'same'), gauss','same');
%g = conv2(conv2(image, gauss,'valid'), gauss','valid');



