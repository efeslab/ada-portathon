function [Hinten,Hbins] = get_hists_inten(J,nbin)
%
%
%  produce histogram output of the image J and its
%    filter outputs Jbar
%


w = size(J);

[Hinten,Hbins] = hist(reshape(J,prod(w),1),linspace(1,256,nbin));




