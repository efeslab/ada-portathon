function ret=quatRot(vec, rQuat)
nr=size(vec,1);
tv = zeros(nr,1);
vQuat=[tv, vec];
temp = quatMul(rQuat, vQuat);
temp1 = quatConj(rQuat);
retVec = quatMul(temp, temp1);
%retVec=quatMul(quatMul(rQuat, vQuat),quatConj(rQuat));
%ret=retVec(:,2:4);
rows = size(retVec, 1);
ret = zeros(rows,3);

for i=1:rows
    k =1;
    for j=2:4
        ret(i,k) = retVec(i,j);
        k = k+1;
    end
end
%size(ret)




