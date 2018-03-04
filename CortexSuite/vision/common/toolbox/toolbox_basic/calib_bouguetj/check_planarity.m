% Check the planarity of a structure:

X = X_1;
N = size(X,2);

%X(3,:) = 0.1*randn(1,N);

om = rand(3,1);
T = 10*rand(3,1);
R = rodrigues(om);

X = R * X  + T*ones(1,N);






N = size(X,2);
X_mean = mean(X')';

Y = X - (X_mean*ones(1,N));

YY = Y*Y';

[U,S,V] = svd(YY);

r = S(3,3)/S(2,2);

% if r is less than 1e-4:

R_transform = V';
T_transform = -(V')*X_mean;


% Thresh for r: 1e-4

X_new = R_transform*X + T_transform*ones(1,N);


% If Xc = Rc * X_new + Tc, then Xc = Rc * R_transform * X + Tc + T_transform
