function retPnts=transformH(H, pnts)
MAX_LIMIT=10000000;
[n temp]=size(pnts);
 
pntsT = pnts';
retPnts=(H*pntsT)';
for i=1:n
    if retPnts(i,3)~=0
        retPnts(i,:)=retPnts(i,:)./retPnts(i,3);
    else
        retPnts(i,:)=[MAX_LIMIT MAX_LIMIT 1];
    end
end
