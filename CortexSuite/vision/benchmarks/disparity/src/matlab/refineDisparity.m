function retDisparity=refineDisparity(Idisp, DispSAD, Ileft, Iright)
[nr nc ndist]=size(DispSAD);
retDisparity=zeros(nr, nc);

IdispNext=padarray(Idisp, [0 1], 'replicate', 'post');
IdispNext=IdispNext(:,2:end);


IdispDiff=abs(Idisp-IdispNext);
idx=find(IdispDiff>1);
[idxI idxJ]=ind2sub([nr, nc], idx);

%if(Idisp(idx)
%sideFlag=
checkedResult= (abs( DispSAD(sub2ind( [nr, nc, ndist], idxI, idxJ, Idisp(idx))) - ...
DispSAD(sub2ind( [nr, nc, ndist], idxI, idxJ+1, Idisp(idx))) ) < 1 )+1;
checkedResult= checkedResult + (abs( DispSAD(sub2ind( [nr, nc, ndist], idxI, idxJ, Idisp(idx+nr))) - ...
DispSAD(sub2ind( [nr, nc, ndist], idxI, idxJ+1, Idisp(idx+nr))) ) < 1 );
retDisparity(idx)=checkedResult;


% IdispDiff=(Idisp-IdispNext);
% idx=find(IdispDiff<-1);
% [idxI idxJ]=ind2sub([nr, nc], idx);
% 
% checkedResult= abs( DispSAD(sub2ind( [nr, nc, ndist], idxI, idxJ, Idisp(idx+nr))) - ...
% DispSAD(sub2ind( [nr, nc, ndist], idxI, idxJ+1, Idisp(idx+nr))) ) < 0.5;
% retDisparity(idx)=checkedResult;



