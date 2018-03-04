function [hists,bins] = get_hists(J,Jbar)
%
%
%  produce histogram output of the image J and its
%    filter outputs Jbar
%

maxval = 60;
bin = [1:4:maxval+1];

w = size(J);


[hists.inten,bins.inten] = hist(reshape(J,prod(w),1),[1:26:256]);

for j=1:size(Jbar,3),
   hists.text(:,j) = hist(reshape(abs(Jbar(:,:,j)),prod(w),1),bin);
end

bins.text = bin;

[hists.mag,bins.mag] = hist(reshape(sum(abs(Jbar),3),prod(w),1),[1:10:161]);


