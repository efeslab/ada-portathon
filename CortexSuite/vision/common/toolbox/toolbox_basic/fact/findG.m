function G = find3G(Rhat)

% number of frames
F = size(Rhat,1)/2;

% Build matrix Q such that Q * v = [1,...,1,0,...,0] where v is a six
% element vector containg all six distinct elements of the Matrix C

clear Q
for f = 1:F,
  g = f + F;
  h = g + F;
  Q(f,:) = zt(Rhat(f,:), Rhat(f,:));
  Q(g,:) = zt(Rhat(g,:), Rhat(g,:));
  Q(h,:) = zt(Rhat(f,:), Rhat(g,:));
end

% Solve for v
rhs = [ones(2*F,1); zeros(F,1)];
v = Q \ rhs;

% C is a symmetric 3x3 matrix such that C = G * transpose(G)
C(1,1) = v(1);                  
C(1,2) = v(2);                  
C(1,3) = v(3);                  
C(2,2) = v(4);
C(2,3) = v(5);
C(3,3) = v(6);
C(2,1) = C(1,2);
C(3,1) = C(1,3);
C(3,2) = C(2,3);

e = eig(C);
disp(e)

if (any(e<= 0)),
  G = [];
else
  G = sqrtm(C);
end

%neg = 0;
%if e(1) <= 0, neg = 1; end
%if e(2) <= 0, neg = 1; end
%if e(3) <= 0, neg = 1; end
%if neg == 1, G = [];
%else G = sqrtm(C);
%end
