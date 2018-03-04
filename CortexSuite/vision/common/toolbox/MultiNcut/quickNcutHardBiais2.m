% function [v,s] = quickNcutHardBiais(W,U,nbEigenValues,dataGraphCut)
%ligne 35 : changement tim
%[v,s] = ncut(W,nbEigenValues,[],offset); 
%devient :
%[v,s] = tim_ncut_rapide(W,nbEigenValues,[],offset);
%et eigs devient tim_eigs

% Input:
%   W = affinity matrix
%   U = hard constraint matrix, could be a cell of partial grouping
%   nbEigenValues = number of eigenvectors
%   offset = regularization factor, default = 0
% Output:
%   v = eigenvector
%   s = eigenvalue of (W,d), s.t. U' * x = 0.

% call eigs using my own * operation

% Stella X. Yu, Jan 2002.

function [v,s] = quickNcutHardBiais2(W,U,nbEigenValues,dataGraphCut)%voir : rajouter sigma
n = size(W,1);
nbEigenValues = min(nbEigenValues,n);

offset = dataGraphCut.offset;
%offset = 2;

% degrees and regularization
d = sum(abs(W),2);
dr = 0.5 * (d - sum(W,2));
d = d + offset * 2;
dr = dr + offset;
W = W + spdiags(dr,0,n,n);
clear dr

% normalize
Dinvsqrt = 1./sqrt(d+eps);
P = spmtimesd(W,Dinvsqrt,Dinvsqrt);
clear W;

% if max(max(P-P')) < 1e-10 %ou eps
%      %S = sparse(1:n,1:n,0.5);
%     P =max(P,P');
%      % P=S*(P+P');
%     %P=0.5*(P+P');
%     options.issym = 1;
% end
P = sparsifyc(P,dataGraphCut.valeurMin);
options.issym = 1;

Ubar = spmtimesd(U,Dinvsqrt,[]);
%Ubar = sparsifyc(Ubar,dataGraphCut.valeurMin); %voir

options.disp = dataGraphCut.verbose;
options.maxit = dataGraphCut.maxiterations;
options.tol = dataGraphCut.eigsErrorTolerance;

options.v0 = ones(size(P,1),1);%voir

options.p = max(35,2*nbEigenValues); %voir
options.p = min(options.p , n);

% nouvelle idee : factorisation de Cholesky
C=Ubar'*Ubar;
%permutation = symamd(C);
%R = cholinc(C(permutation,permutation));
t_chol_Ubar = cputime;
[R,ooo] = cholinc(C,'0');
t_chol_Ubar = cputime - t_chol_Ubar;
%if error occurs, check if Ubar = sparsifyc(Ubar,dataGraphCut.valeurMin);
%sparsifies too much


% compute  H = (Ubar'*Ubar)^(-1)
% t_inv_H = cputime;
% H = inv(sparsifyc(Ubar' * Ubar,dataGraphCut.valeurMin)); %changer
% t_inv_H = cputime - t_inv_H;
% H = sparsifyc(H,dataGraphCut.valeurMin);
% tEigs = cputime;
% if options.issym & max(max(H-H')) < 1e-10
%     [vbar,s,convergence] = tim_eigs(@mex_projection_inv_symmetric,n,nbEigenValues,'lm',options,triu(P),Ubar,triu(H)); 
% else
%     [vbar,s,convergence] = tim_eigs(@mex_projection_inv,n,nbEigenValues,'lm',options,P,Ubar,H); 
% end
% tEigs = cputime - tEigs;
% 



R = sparsifyc(R,dataGraphCut.valeurMin);
tEigs = cputime;
if options.issym
    [vbar,s,convergence] = tim_eigs(@mex_projection_QR_symmetric,n,nbEigenValues,'lm',options,tril(P),Ubar,R); 
else
    [vbar,s,convergence] = tim_eigs(@mex_projection_QR,n,nbEigenValues,'lm',options,P,Ubar,R); 
end
tEigs = cputime - tEigs;


%afficheTexte(sprintf('\n\nTemps ecoule pendant eigs : %g',tEigs),dataGraphCut.verbose,2);
%afficheTexte(sprintf('\nTemps ecoule pendant chol(Ubar''*Ubar) : %g',t_chol_Ubar),dataGraphCut.verbose);
if convergence~=0
    afficheTexte(sprintf('  (Non-convergence)'),dataGraphCut.verbose);
end


%disp(sprintf('nnz(P) : %f\n',nnz(P)));
%disp(sprintf('nnz(Ubar) : %f\n',nnz(Ubar)));
%disp(sprintf('nnz(R) : %f\n',nnz(R)));
%disp(sprintf('nnz(global) : %f\n',nnz(P) + 4 * nnz(Ubar) + 4*nnz(R)));



s = real(diag(s));
[x,y] = sort(-s); 
s = -x;
vbar = vbar(:,y);


v = spdiags(Dinvsqrt,0,n,n) * vbar;

for  i=1:size(v,2)
    %v(:,i) = v(:,i) / max(abs(v(:,i)));
    v(:,i) = (v(:,i) / norm(v(:,i))  )*norm(ones(n,1));
    if v(1,i)~=0
        v(:,i) = - v(:,i) * sign(v(1,i));
    end
end

% % nouvelle idee : factorisation de Cholesky
% t_chol_Ubar = cputime;
% R = chol(Ubar' * Ubar);
% t_chol_Ubar = cputime - t_chol_Ubar;
% R = sparsifyc(R,dataGraphCut.valeurMin);
% tEigs = cputime;
% if options.issym
%     [vbar,s,convergence] = tim_eigs(@mex_projection_QR_symmetric,n,nbEigenValues,'lm',options,triu(P),Ubar,R); 
% else
%     [vbar,s,convergence] = tim_eigs(@mex_projection_QR,n,nbEigenValues,'lm',options,P,Ubar,R); 
% end
% tEigs = cputime - tEigs;


% % compute H = (Ubar'*Ubar)^(-1)
% t_inv_H = cputime;
% H = inv(sparsifyc(Ubar' * Ubar,dataGraphCut.valeurMin)); %changer
% t_inv_H = cputime - t_inv_H;
% H = sparsifyc(H,dataGraphCut.valeurMin);
% tEigs = cputime;
% if options.issym & max(max(H-H')) < 1e-10
%     [vbar,s,convergence] = tim_eigs(@mex_projection_inv_symmetric,n,nbEigenValues,'lm',options,triu(P),Ubar,triu(H)); 
% else
%     [vbar,s,convergence] = tim_eigs(@mex_projection_inv,n,nbEigenValues,'lm',options,P,Ubar,H); 
% end
% tEigs = cputime - tEigs;



% % idee de mon rapport... semble pas marcher car R = qr(Ubar,0) est plus
% % lent que H = inv(sparsifyc(Ubar' * Ubar,dataGraphCut.valeurMin));
% t_qr_Ubar = cputime;
% R = qr(Ubar,0);
% t_qr_Ubar = cputime - t_qr_Ubar;
% R = sparsifyc(R,dataGraphCut.valeurMin);
% tEigs2 = cputime;
% if options.issym
%     [vbar2,s2,convergence] = tim_eigs(@mex_projection_QR_symmetric,n,nbEigenValues,'lm',options,triu(P),Ubar,R); 
% else
%     [vbar2,s2,convergence] = tim_eigs(@mex_projection_QR,n,nbEigenValues,'lm',options,P,Ubar,R); 
% end
% tEigs2 = cputime - tEigs2;



% idee de Jianbo... semble pas marcher car on a besoin de prendre k maximal
% dans [A,S,B] = svds(Ubar,k);
% 
% [A,S,B] = svds(Ubar,300);
% A = sparsifyc(A,dataGraphCut.valeurMin); 
% tEigs = cputime;
% [vbar,s,convergence] = tim_eigs(@mex_projection_svd,n,nbEigenValues,'lm',options,P,A); 

% afficheTexte(sprintf('\ninv(H) : %g',t_inv_H),dataGraphCut.verbose);
% afficheTexte(sprintf('\n\nTemps ecoule pendant eigs : %g',tEigs2),dataGraphCut.verbose,2);
% afficheTexte(sprintf('\nqr(Ubar) : %g',t_qr_Ubar),dataGraphCut.verbose);
% disp(sprintf('nnz(H) : %f\n',nnz(H)));
% disp(sprintf('nnz(global) : %f\n',nnz(P) + 4 * nnz(Ubar) + 2*nnz(H)));
