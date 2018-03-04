function [interestPnts]=getANMS(x, y, v, r, dataDir)
%interestPnts=[x y v]
MAX_LIMIT=100000000;
C_ROBUST=0.9;
r_sq=r^2;
points=[x y v];
[n temp]=size(v);
[srtdV srtdVIdx]=sort(v,'descend');
srtdPnts=points(srtdVIdx,:);

interestPnts=zeros(0,3);

suppressR=ones(n,1)*MAX_LIMIT;
supId=find(suppressR>r_sq);

iter = 0;
while length(supId)>0
    interestPnts=[interestPnts; srtdPnts(supId(1),:)];
    srtdPnts=srtdPnts(supId(2:end),:);
    suppressR=suppressR(supId(2:end),:);
    
    suppressR=min(suppressR,(C_ROBUST*interestPnts(end,3)>srtdPnts(:,3)).*((srtdPnts(:,1)-interestPnts(end,1)).^2 + (srtdPnts(:,2)-interestPnts(end,2)).^2)+(C_ROBUST*interestPnts(end,3)<=srtdPnts(:,3))*MAX_LIMIT);
    supId=find(suppressR>r_sq);
    iter = iter + 1;
end
