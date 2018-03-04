function [NcutDiscretes,eigenVectors,eigenValues] = MNcut(I,nsegs);
%
%  [NcutDiscrete,eigenVectors,eigenValues] = MNcut(I,nsegs);
%  
%

[nr,nc,nb] = size(I);

max_image_size = max(nr,nc);

% modified by song, 06/13/2005
%   test parameters
if (1) % original settings
    if (max_image_size>120) & (max_image_size<=500),
        % use 3 levels,
        data.layers.number=3;
        data.layers.dist=3;
        data.layers.weight=[3000,4000,10000];
        data.W.scales=[1,2,3];%[1,2,3];
        data.W.radius=[2,3,7];%[2,3,7];
    elseif (max_image_size >500),
        % use 4 levels,
        data.layers.number=4;
        data.layers.dist=3;
        data.layers.weight=[3000,4000,10000,20000];
        data.W.scales=[1,2,3,3];
        data.W.radius=[2,3,4,6];
    elseif (max_image_size <=120)
        data.layers.number=2;
        data.layers.dist=3;
        data.layers.weight=[3000,10000];
        data.W.scales=[1,2];
        data.W.radius=[2,6];
    end
else % test setting
    if (max_image_size>200) & (max_image_size<=500),
        % use 3 levels,
        data.layers.number=3;
        data.layers.dist=3;
        data.layers.weight=[3000,4000,10000];
        data.W.scales=[1,2,3];%[1,2,3];
        data.W.radius=[2,3,7];%[2,3,7];
    elseif (max_image_size >500),
        % use 4 levels,
        data.layers.number=4;
        data.layers.dist=3;
        data.layers.weight=[3000,4000,10000,20000];
        data.W.scales=[1,2,3,3];
        data.W.radius=[2,3,4,6];
    elseif (max_image_size <=200)
        data.layers.number=2;
        data.layers.dist=3;
        data.layers.weight=[3000,10000];
        data.W.scales=[1,2];
        data.W.radius=[2,4];
    end

end;


data.W.edgeVariance=0.1; %0.1
data.W.gridtype='square';
data.W.sigmaI=0.12;%0.12
data.W.sigmaX=1000;
data.W.mode='mixed';    
data.W.p=0;
data.W.q=0;

%eigensolver
data.dataGraphCut.offset = 100;% 10; %valeur sur diagonale de W (mieux vaut 10 pour valeurs negatives de W)
data.dataGraphCut.maxiterations=50;% voir
data.dataGraphCut.eigsErrorTolerance=1e-2;%1e-6;
data.dataGraphCut.valeurMin=1e-6;%1e-5;% utilise pour tronquer des valeurs et sparsifier des matrices
data.dataGraphCut.verbose = 0;

data.dataGraphCut.nbEigenValues=max(nsegs);

disp('computeEdge');
[multiWpp,ConstraintMat, Wind,data,emag,ephase]= computeMultiW (I,data);

disp('Ncut');
[eigenVectors,eigenValues]= eigSolve (multiWpp,ConstraintMat,data);

%NcutDiscretes = zeros(nr,nc,length(nsegs));
NcutDiscretes = zeros(nr,nc,(nsegs));

for j=1:length(nsegs),
	nseg = nsegs(j);
        [nr,nc,nb] = size(eigenVectors(:,:,1:nseg));
        [NcutDiscrete,evrotated] =discretisation(reshape(eigenVectors(:,:,1:nb),nr*nc,nb),nr,nc);
         NcutDiscretes(:,:,j) = NcutDiscrete;
end

