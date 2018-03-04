function cumhists = get_cumhist(hists)
%
%
%     cumhists = get_cumhist(hists)
%

cumhists.inten = cumsum(hists.inten)/sum(hists.inten);
cumhists.text = cumsum(hists.text,1)./(ones(size(hists.text,1),1)*sum(hists.text,1));
cumhists.mag = cumsum(hists.mag)/sum(hists.mag);