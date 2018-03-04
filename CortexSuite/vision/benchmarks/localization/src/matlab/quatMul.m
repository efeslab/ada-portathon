function retQuat=quatMul(a, b)

rowsa = size(a,1);
colsa = size(a,2);

rowsb = size(b,1);
colsb = size(b,2);

retQuat=[a(:,1).*b(:,1) - a(:,2).*b(:,2) - a(:,3).*b(:,3) - a(:,4).*b(:,4) ...
    a(:,1).*b(:,2) + a(:,2).*b(:,1) + a(:,3).*b(:,4) - a(:,4).*b(:,3) ...
    a(:,1).*b(:,3) - a(:,2).*b(:,4) + a(:,3).*b(:,1) + a(:,4).*b(:,2) ...
    a(:,1).*b(:,4) + a(:,2).*b(:,3) - a(:,3).*b(:,2) + a(:,4).*b(:,1)];

% disp('retQuat');
% disp(retQuat);



