function [retX, retW]=mcl(x,sData, invCov)
%instead of using importance resampling, I assumed 3D gaussian for each
%particle
%retX=x+randn(nr,nc)*(invCov^-1); %add noise
retX=x;
retW=get3DGaussianProb(retX, sData, invCov);
retW=retW/sum(retW);


