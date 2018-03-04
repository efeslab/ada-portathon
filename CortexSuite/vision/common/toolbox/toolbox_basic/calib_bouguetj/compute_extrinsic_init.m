function [omckk,Tckk,Rckk] = compute_extrinsic_init(x_kk,X_kk,fc,cc,kc),

%compute_extrinsic
%
%[omckk,Tckk,Rckk] = compute_extrinsic_init(x_kk,X_kk,fc,cc,kc)
%
%Computes the extrinsic parameters attached to a 3D structure X_kk given its projection
%on the image plane x_kk and the intrinsic camera parameters fc, cc and kc.
%Works with planar and non-planar structures.
%
%INPUT: x_kk: Feature locations on the images
%       X_kk: Corresponding grid coordinates
%       fc: Camera focal length
%       cc: Principal point coordinates
%       kc: Distortion coefficients
%
%OUTPUT: omckk: 3D rotation vector attached to the grid positions in space
%        Tckk: 3D translation vector attached to the grid positions in space
%        Rckk: 3D rotation matrices corresponding to the omc vectors
%
%Method: Computes the normalized point coordinates, then computes the 3D pose
%
%Important functions called within that program:
%
%normalize: Computes the normalize image point coordinates.
%
%pose3D: Computes the 3D pose of the structure given the normalized image projection.
%
%project_points.m: Computes the 2D image projections of a set of 3D points




if nargin < 5,
   kc = zeros(4,1);
   if nargin < 4,
      cc = zeros(2,1);
      if nargin < 3,
         fc = ones(2,1);
         if nargin < 2,
            error('Need 2D projections and 3D points (in compute_extrinsic.m)');
            return;
         end;
      end;
   end;
end;



% Compute the normalized coordinates:

xn = normalize(x_kk,fc,cc,kc);



Np = size(xn,2);

%% Check for planarity of the structure:

X_mean = mean(X_kk')';

Y = X_kk - (X_mean*ones(1,Np));

YY = Y*Y';

[U,S,V] = svd(YY);

r = S(3,3)/S(2,2);

if (r < 1e-3)|(Np < 6), %1e-3, %1e-4, %norm(X_kk(3,:)) < eps, % Test of planarity
   
   %fprintf(1,'Planar structure detected: r=%f\n',r);

   % Transform the plane to bring it in the Z=0 plane:
   
   R_transform = V';
   
   if det(R_transform) < 0, R_transform = -R_transform; end;
   
	T_transform = -(R_transform)*X_mean;

	X_new = R_transform*X_kk + T_transform*ones(1,Np);
   
   
   % Compute the planar homography:
   
   H = compute_homography (xn,X_new(1:2,:));
   
   % De-embed the motion parameters from the homography:
   
   sc = mean([norm(H(:,1));norm(H(:,2))]);
   
   H = H/sc;
   
   omckk = rodrigues([H(:,1:2) cross(H(:,1),H(:,2))]);
   Rckk = rodrigues(omckk);
   Tckk = H(:,3);
   
   %If Xc = Rckk * X_new + Tckk, then Xc = Rckk * R_transform * X_kk + Tckk + T_transform
   
   Tckk = Tckk + Rckk* T_transform;
   Rckk = Rckk * R_transform;

   omckk = rodrigues(Rckk);
   Rckk = rodrigues(omckk);
   
   
else
   
   %fprintf(1,'Non planar structure detected: r=%f\n',r);

   % Computes an initial guess for extrinsic parameters (works for general 3d structure, not planar!!!):
   % The DLT method is applied here!!
   
   J = zeros(2*Np,12);
	
	xX = (ones(3,1)*xn(1,:)).*X_kk;
	yX = (ones(3,1)*xn(2,:)).*X_kk;
	
	J(1:2:end,[1 4 7]) = -X_kk';
	J(2:2:end,[2 5 8]) = X_kk';
	J(1:2:end,[3 6 9]) = xX';
	J(2:2:end,[3 6 9]) = -yX';
	J(1:2:end,12) = xn(1,:)';
	J(2:2:end,12) = -xn(2,:)';
	J(1:2:end,10) = -ones(Np,1);
	J(2:2:end,11) = ones(Np,1);
	
	JJ = J'*J;
	[U,S,V] = svd(JJ);
   
   RR = reshape(V(1:9,12),3,3);
   
   if det(RR) < 0,
      V(:,12) = -V(:,12);
      RR = -RR;
   end;
   
   [Ur,Sr,Vr] = svd(RR);
   
   Rckk = Ur*Vr';
   
   sc = norm(V(1:9,12)) / norm(Rckk(:));
   Tckk = V(10:12,12)/sc;
   
	omckk = rodrigues(Rckk);
   Rckk = rodrigues(omckk);
   
end;
