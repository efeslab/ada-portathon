% gradient of an image
% coordinates (r, c) follow matrix convention;
% the gaussian is truncated at x = +- tail, and there are samples samples
% inbetween, where samples = hsamples * 2 + 1

function[gr,gc] = gradient(image, hsamples)

tail=4;
samples = hsamples * 2 + 1;

x = linspace(-tail, tail, samples);
gauss = exp(-x.^2);
n = gauss * ones(samples,1);
gauss = gauss/n;

gaussderiv = -x.*gauss;
n = -gaussderiv*linspace(1,samples,samples)';
gaussderiv = gaussderiv/n;

gr = conv2(conv2(image, gaussderiv','valid'), gauss,'valid');
gc = conv2(conv2(image, gaussderiv,'valid'), gauss','valid');

%gr = conv2(conv2(image, gaussderiv','same'), gauss,'same');
%gc = conv2(conv2(image, gaussderiv,'same'), gauss','same');
