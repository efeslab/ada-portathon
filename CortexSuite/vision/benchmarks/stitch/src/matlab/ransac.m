function [retH retPntsIdx]=ransac(pntsPrev, pntsCur, k, epsilon)
[n temp]=size(pntsPrev);
pntsPrev=[pntsPrev(:,1:2) ones(n,1)];
pntsCur=[pntsCur(:,1:2) ones(n,1)];

inlierIdx=cell(k,1);
inlierNum=zeros(k,1);
for i=1:k
    seed=randperm(n);
    H=calculateH(pntsPrev(seed(1:4),:), pntsCur(seed(1:4),:));
    err=(pntsCur-transformH(H,pntsPrev));
    inlierIdx{i}=find(sum(err(:,1:2).^2,2) < epsilon);
    inlierNum=length(inlierIdx{i});
end

[v maxIdx]=max(inlierNum);
retPntsIdx=inlierIdx{maxIdx};
retH=calculateH(pntsPrev(retPntsIdx,:), pntsCur(retPntsIdx,:));

