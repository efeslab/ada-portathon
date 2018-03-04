function [binv,bins] = binize(data,sig,bin_min,bin_max,num_bin)
%
%  given an input data, and sigma which describes the uncertainty
%  of the data, along with information on the bins,
%  return the soft-hist on data
%

ndata = length(data);

if 0,
bins = linspace(bin_min,bin_max,num_bin);
binv = zeros(num_bin,ndata);

Largev = 1000;

bins = [-Largev,bins];

for j=1:num_bin,
    binv(j,:) = erf((bins(j+1)-data)/sig) - erf((bins(j)-data)/sig);
end

binv(num_bin,:) = binv(num_bin,:) + erf((Largev-data)/sig) - erf((bins(end)-data)/sig);
bins = bins(2:end);
else

bins = linspace(bin_min,bin_max,num_bin+1);
binv = zeros(num_bin,ndata);


for j=1:num_bin,
    binv(j,:) = erf((bins(j+1)-data)/sig) - erf((bins(j)-data)/sig);
end

end