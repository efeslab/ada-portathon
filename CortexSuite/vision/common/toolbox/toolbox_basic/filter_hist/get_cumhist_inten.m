function CH_inten = get_cumhist(hists)
%
%
%     cumhists = get_cumhist(hists)
%

CH_inten = cumsum(hists)/sum(hists);
