function retQuat=quatConj(a)
rows = size(a,1);
retQuat = zeros(rows, 4);
retQuat=[a(:,1), -a(:,2), -a(:,3), -a(:,4)];
         
