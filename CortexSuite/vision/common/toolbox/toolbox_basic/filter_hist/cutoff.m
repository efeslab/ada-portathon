function I = cutoff(I,wc)
%
%

nr = size(I,1);
nc = size(I,2);

if ndims(I) == 3,
I = I(wc+1:nr-wc,wc+1:nc-wc,:,:);
else
I = I(wc+1:nr-wc,wc+1:nc-wc,:,:);
end

