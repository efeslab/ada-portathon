function [eigenVectors,s]= eigSolve (multiWpp,ConstraintMat,data)

[v,s] = quickNcutHardBiais2(multiWpp,ConstraintMat,data.dataGraphCut.nbEigenValues,data.dataGraphCut);
v=v(1:data.p(1)*data.q(1),:);
eigenVectors=reshape(v,data.p(1),data.q(1),data.dataGraphCut.nbEigenValues);
