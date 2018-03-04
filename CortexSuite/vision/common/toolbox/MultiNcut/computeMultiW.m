%inputs : image, number of layers, distance defining the subgrid, the edge filter scales for each layer, radius for each layer,
%edge variance for filter, shape of the neighbourhood layout ('square', 'star', 'cross'), sigma for intensity affinity,
% sigma for distance influence in affinity, weight coefficients for Wpps in the multiscale matrix.
%output : multiscale affinity matrix , extern constraint matrix, affinity matrices of each layer seperatly.


function [multiWpp,constraintMat, Wind,data,emag,ephase]= computeMultiW (image,data);

%variables

if  isempty(data.layers.number)
    n=2;
else
    n=data.layers.number;
end

if isempty(data.layers.dist)
    dist_grid=3;
else
    dist_grid=data.layers.dist;
end

if isempty(data.W.scales)
    s=1:n;
elseif (length(data.W.scales)==n)
    s=data.W.scales;
else
    s=1:n;
end

if isempty(data.W.radius)
    r(1)=2;
    for i=2:n
        r(i)=10;
    end
else
    r=data.W.radius;
end


if isempty(data.W.edgeVariance)
    data.W.edgeVariance=0.1;
end

if isempty(data.W.gridtype)
    data.W.gridtype='square';
end

if isempty(data.W.sigmaI)
    data.W.sigmaI=0.12;
end

if isempty(data.W.sigmaX)
    data.W.sigmaX=10;
end

if isempty(data.layers.weight)
    coef(1)=5;
    coef(2:n)=200;
elseif (length(data.layers.weight)==n)
    coef=data.layers.weight;
else
    coef(1)=5;
    coef(2:n)=100;  %200  
end

if isempty(data.W.mode)
    data.W.mode=mixed;
end


[p1,q1,ignore]=size(image);
image=image(:,:,1);
filter_par = [4,30,4];  %[9,30,4]
[x,y,gx,gy,par,threshold,emag,ephase,g,FIe,FIo,mago] = quadedgep2(image,filter_par,data,0.001);
minW=10^(-2); %-3


% function [multiWpp,constraintMat,p,q,Wppp,subgrid] = computemultiWpp(n,imageX,r,dist_grid,s,dataWpp,emag,ephase,minW,mode,facteurMul,contrainte,tt,gridtype,colormode,imageOriginale,subgridImageReduite,pG,qG)

p= p1*ones(n,1);
q= q1*ones(n,1);
d= dist_grid*ones(n,1);
d(1)=1;
for (i=2:n)
    d(i)=d(i)*3^(i-2);
end
p=ceil(p1./d);
q=ceil(q1./d);

%computation of the subgrids (the first pixel is coded by one). S{i,j}(k) is the index of
%the kth pixel of the jth grid in the ith grid.

for i=1:n-1
    for j=i+1:n
        a=[0:p(j)*q(j)-1];
        subgrid{i,j}=p(i)*(floor(a/p(j)))*d(j)/d(i)+(1+mod(a,p(j))*d(j)/d(i));
    end
end

%computation of the independent W matrix for each layer Wind{i} 1=<i=<n.

[w1i,w1j]=cimgnbmap([p1,q1], r(1), 1);

if strcmp(data.W.mode,'mixed')
    rMin = 0;
    imageXX=double(image(:));
    sigmaI= (std(imageXX(:)) + 1e-10 )* data.W.sigmaI;
    Wpp{1} = multiIntensityFirstLayer(double(image),w1i,w1j,rMin,data.W.sigmaX,sigmaI,minW);
    Wpp2= affinityic(emag(:,:,s(1)),ephase(:,:,s(1)),w1i,w1j,max(max(emag(:,:,s(1)))) * data.W.edgeVariance);
    Wpp{1} = sqrt(Wpp{1} .* Wpp2)+0.1*Wpp2;
    
elseif strcmp(data.W.mode,'notmixed')
    Wpp{1}= affinityic(emag(:,:,s(1)),ephase(:,:,s(1)),w1i,w1j,max(max(emag(:,:,s(1)))) * data.W.edgeVariance);
    
elseif strcmp(data.W.mode,'intensity')
    rMin = 0;
    imageXX=double(image(:));
    sigmaI= (std(imageXX(:)) + 1e-10 )* data.W.sigmaI;
    Wpp{1} = multiIntensityFirstLayer(double(image),w1i,w1j,rMin,data.W.sigmaX,sigmaI,minW);  
    
end
Wpp{1}=coef(1)*(Wpp{1}+Wpp{1}')/2;
%Wpp{1}= coef(1)*Wpp{1};
Wind{1}=Wpp{1};




for i=2:n 
    if strcmp(data.W.gridtype,'square')
        [wwi,wwj]=cimgnbmap([p(i),q(i)], r(i), 1); 
    elseif strcmp(data.W.gridtype,'star')
        [wwi,wwj]=cimgnbmap_star([p(i),q(i)], r(i), 1);
    elseif strcmp(data.W.gridtype,'cross')
        [wwi,wwj]=cimgnbmap_cross([p(i),q(i)], r(i), 1);
    end
    wwi=double(wwi);
    wiInOriginalImage=(p1*(floor(wwi/p(i)))*d(i))+(1+mod(wwi,p(i))*d(i));
        wiInOriginalImage=(p1*(floor(wwi/p(i)))*d(i))+(1+mod(wwi,p(i))*d(i));

    wiInOriginalImage= uint32(wiInOriginalImage);

if strcmp(data.W.mode,'mixed')
    Wpp2= multiAffinityic(emag(:,:,i),ephase(:,:,i),wiInOriginalImage,wwj,subgrid{1,i},p(i),q(i),uint32(wwi),max(max(emag(:,:,i))) * data.W.edgeVariance);
    a=floor(d(i)/d(i-1));
    if (mod(a,2)==0)
        a=a+1;
    end
%     Wpp{i} = multiIntensityWppc(double(imageX),wiInOriginalImage,wwj,rMin,dataWpp.sigmaX,sigmaI,minW,subgrid{1,i},p(i),q(i),wi{i});
    
    Wpp{i} = multiIntensityWppc(double(image),wiInOriginalImage,wwj,rMin,data.W.sigmaX,sigmaI,minW,subgrid{1,i},p(i),q(i),uint32(wwi));
    Wpp{i} = sqrt(Wpp{i} .* Wpp2)+0.1*Wpp2;
elseif strcmp(data.W.mode,'notmixed')
    Wpp{i}= multiAffinityic(emag(:,:,i),ephase(:,:,i),wiInOriginalImage,wwj,subgrid{1,i},p(i),q(i),uint32(wwi),max(max(emag(:,:,i))) * data.W.edgeVariance);
elseif strcmp(data.W.mode,'intensity')
    Wpp{i} = multiIntensityWppc(double(image),wiInOriginalImage,wwj,rMin,data.W.sigmaX,sigmaI,minW,subgrid{1,i},p(i),q(i),uint32(wwi));
end
Wpp{i}= coef(i)*(Wpp{i}+Wpp{i}')/2;

%Wpp{i}= coef(i)*Wpp{i};
Wind{i}=Wpp{i};

end

%computation of the intern contraint matrices C{i,j}.

for i=1:n-1
    r=floor(d(i+1)/(d(i)*2));
    [wwi,wwj]=cimgnbmap([p(i),q(i)], r, 1);
    wi{i}=wwi;
    wj{i}=wwj;
end

for i=1:n-1
    for j=i+1:n
        C{i,j}=sparse(p(i)*q(i),p(j)*q(j));
        firstPointer=double(wj{i}(subgrid{i,j}))+1;   
        lastPointer=double(wj{i}(subgrid{i,j}+1));
        invNbNeighbours=1./(lastPointer-firstPointer+1);
        for (k=1:p(j)*q(j))
            for (m=firstPointer(k):lastPointer(k))
                C{i,j}(double(wi{i}(m))+1,k)=invNbNeighbours(k);
            end
        end
    end
end
            
%Assembling the built matrices to make up multiWpp.
for i=1:n
    if (i>1)
        for j=i-1:-1:1
            Wpp{i}=[C{j,i}',Wpp{i}];
        end
    end
    if (i<n)
        for j=i+1:n
            Wpp{i}=[Wpp{i},C{i,j}];
        end
    end
end

% %Assembling the built matrices to make up Wpp without intern constrains.
% for i=1:n
%     if (i>1)
%         for j=i-1:-1:1
%             Wpp{i}=[sparse(p(i)*q(i),p(j)*q(j)),Wpp{i}];
%         end
%     end
%     if (i<n)
%         for j=i+1:n
%             Wpp{i}=[Wpp{i},sparse(p(i)*q(i),p(j)*q(j))];
%         end
%     end
% end

clear Wind;Wind = 1;

multiWpp=Wpp{1}; clear Wpp{1}
for i=2:n
    multiWpp=[multiWpp;Wpp{i}];clear Wpp{i}
end

 
% Computing the average extern constraint

 pq=sum(p(2:n).*q(2:n));
 p2q2=p(2)*q(2);
 constraintMat=[-C{1,2};speye(p2q2);sparse(pq-p2q2,p2q2)];
 if n>2
     for i=3:n
         piqi=p(i)*q(i);
         if i~=n
             constraintMat=[constraintMat,[sparse(sum(p(1:i-2).*q(1:i-2)),piqi);-C{i-1,i};speye(piqi);sparse(pq-sum(p(2:i).*q(2:i)),piqi)]];
         else
             constraintMat=[constraintMat,[sparse(sum(p(1:i-2).*q(1:i-2)),piqi);-C{i-1,i};speye(piqi)]];
         end
     end
 end

 % saving useful information
 %subgrids, p and q
 data.subgrid=subgrid;
 data.p=p;
 data.q=q;
