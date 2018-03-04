function retData=getGroundData(data, tStamp)
idx=find(data(:,1)==tStamp);
retData=data(idx,:);


