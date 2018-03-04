function retMatch=matchFeatures(vecF1, vecF2)
[n1 temp]=size(vecF1);
[n2 temp]=size(vecF2);

retMatch=zeros(0,2);

for i=1:n1
    [val id]=sort(dist2(vecF1(i,:),vecF2));
    if val(2)~=0 & val(1)/val(2)<0.65
        retMatch=[retMatch; i id(1)];
    end
end
        
