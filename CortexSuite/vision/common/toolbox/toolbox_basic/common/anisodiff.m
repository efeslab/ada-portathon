function [outimage] = anisodiff(inimage,iterations,K)
% [outimage] = anisodiff(inimage,iterations,K)
% Pietro's anisotropic diffusion routine

lambda = 0.25;
outimage = inimage;    [m,n] = size(inimage);

rowC = [1:m];     rowN = [1 1:m-1];     rowS = [2:m m];
colC = [1:n];     colE = [1 1:n-1];     colW = [2:n n];

for i=1:iterations,
   deltaN = outimage(rowN,colC) - outimage(rowC,colC);
   deltaE = outimage(rowC,colE) - outimage(rowC,colC);

   fluxN = deltaN .* exp( - ((1/K) * abs(deltaN)).^2 );
   fluxE = deltaE .* exp( - ((1/K) * abs(deltaE)).^2 );
   
   outimage = outimage + lambda * (fluxN - fluxN(rowS,colC) + fluxE - fluxE(rowC,colW)); 
end

