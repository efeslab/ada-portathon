function [retQuat retVel retPos]=generateSample(w, quat, vel, pos, STDDEV_VEL, STDDEV_POS)
sampledXId=weightedSample(w);

rows = size(sampledXId, 1);
cols = size(sampledXId, 2);

if(cols > 1)
    disp(123456);
end

% retQuat = zeros(rows, 1);
% retVel = zeros(rows, 1);
% retPos = zeros(rows, 1);

% for i=1:rows
%     retQuat(i,1) = quat(sampleXId(i,1),1);
%     retVel(i,1) = vel(sampleXId(i,1),1) + randnWrapper(1,1) * STDDEV_VEL;
%     retPos(i,1) = pos(sampleXId(i,1),1) + randnWrapper(1,1) * STDDEV_POS;    
% end

retQuat=quat(sampledXId,:);
retVel=vel(sampledXId,:);%+randnWrappern(n,3)*STDDEV_VEL;
retPos=pos(sampledXId,:);%+randnWrappern(n,3)*STDDEV_POS;


