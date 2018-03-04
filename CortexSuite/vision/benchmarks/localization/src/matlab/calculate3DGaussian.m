function [meanColor A]=calculate3DGaussian(data)
n_data=size(data,1);
n_channel=size(data,2);
meanColor=mean(data);
diff=double(data)-ones(n_data,1)*meanColor;
diifTr = transpose(diff);
Ainv=(diffTr*diff/n_data);
AinvTr = transpose(Ainv);
A=inv(AinvTr);


