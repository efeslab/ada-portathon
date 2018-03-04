function retH=calculateH(pnt1, pnt2)

[n temp]=size(pnt1);

X=zeros(0,8);
b=zeros(0,1);

for i=1:n
    X=[X; pnt1(i,1) pnt1(i,2) 1 0 0 0 -pnt2(i,1)*pnt1(i,1) -pnt2(i,1)*pnt1(i,2);0, 0, 0, pnt1(i,1), pnt1(i,2), 1, -pnt2(i,2)*pnt1(i,1), -pnt2(i,2)*pnt1(i,2)];
    b=[b; pnt2(i,1); pnt2(i,2)];
end

if n==4
    %if abs(det(X)~=0
        H=X^(-1)*b;
    %else
    %    H=[0 0 0; 0 0 0; 0 0 1];
    %end
else
    Xt = X';
    H=(Xt*X)^(-1)*Xt*b;
end

retH=[H(1) H(2) H(3);H(4) H(5) H(6);H(7) H(8) 1];
