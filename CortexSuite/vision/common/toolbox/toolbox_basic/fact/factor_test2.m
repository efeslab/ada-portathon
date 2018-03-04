%
% Usage:
%
%    [R,t,S] = factor(W)
%
% Function to factor a matrix of input data (W) into the camera
% rotation matrix (R), translation (t), and the shape matrix (S).
% Three-dimensional version. Failure of normalization results in
% empty R and S.

function [R,t,S,C,b] = factor(W)

pts = size(W,2);
t = W*ones(pts,1)/pts;
W = W - t*ones(1,pts);

% Use SVD to factor W. 
   [a,b,c] = svd(W,0);

figure(3);plot(diag(b))
 
smallb = b(1:3,1:3);	% Since W is rank 3, b has only three meaningful values
sqrtb = sqrt(smallb);
Rhat = a(:,1:3) * sqrtb;
Shat = sqrtb * c(:,1:3)';

[G,C] = findg2(Rhat);

if size(G,1) == 0,
R = [];
S = [];
else
  R = Rhat*G;
  S = inv(G)*Shat;

  % rotation matrix that aligns the reference frame with the first camera
  F = size(R,1)/2;
  R1 = R(1,:);
  R1 = R1/norm(R1);
  R2 = R(F+1,:);
  R2 = R2/norm(R2);
  R3 = cross(R1,R2);
  R3 = R3/norm(R3);
  P = [R1; R2; R3];
  P = P';

  R = R*P;
  S = inv(P)*S;
end



