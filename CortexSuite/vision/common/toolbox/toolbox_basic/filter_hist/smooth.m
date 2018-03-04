% smooth an image
% coordinates (r, c) follow matrix convention;
% the gaussian is truncated at x = +- tail, and there are samples samples
% inbetween, where samples = hsamples * 2 + 1

function g = smooth(image, hsamples)

tail=4;
samples = hsamples * 2 + 1;

x = linspace(-tail, tail, samples);
gauss = exp(-x.^2);
n = gauss * ones(samples,1);
gauss = gauss/n;


g = conv2(conv2(image, gauss), gauss');

g = conv_trim(g, hsamples, hsamples);

