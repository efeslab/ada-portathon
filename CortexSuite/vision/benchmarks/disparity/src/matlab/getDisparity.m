function [retDisparity retSAD minSAD]=getDisparity(Ileft, Iright, win_sz, max_shift)
Ileft=double(Ileft);
Iright=double(Iright);
[nr,nc,nb]=size(Ileft);
retSAD=zeros(nr, nc, max_shift);

if(win_sz > 1)
    half_win_sz=win_sz/2;
    IleftPadded=padarray(Ileft, [half_win_sz, half_win_sz]);
    IrightPadded=padarray(Iright, [half_win_sz, half_win_sz]);
    for i=1:max_shift   
        retSAD(:,:,i)=correlateSAD(IleftPadded,IrightPadded, win_sz, i-1);
    end
    [minSAD retDisparity]=min(retSAD,[],3);
else
    IleftPadded = Ileft;
    IrightPadded = Iright;
    retSAD=correlateSAD(IleftPadded,IrightPadded, win_sz, 0);
    [minSAD retDisparity]=min(retSAD,[],3);
end
end

function retSAD=correlateSAD(Ileft, Iright, win_sz, disparity)

Iright_moved=padarray(Iright, [0,disparity], 'pre');    
Iright_moved=Iright_moved(:, 1:end-disparity,:);

[rows, cols] = size(Ileft);
for i=1:rows
    for j=1:cols
        diff = Ileft(i,j) - Iright_moved(i,j);
        SAD(i,j) = diff * diff;
    end
end

%2D scan.
integralImg=integralImage2D(SAD);
retSAD=integralImg(win_sz+1:end,win_sz+1:end,:) +integralImg(2:end-win_sz+1,2:end-win_sz+1,:)-integralImg(2:end-win_sz+1,win_sz+1:end,:)-integralImg(win_sz+1:end,2:end-win_sz+1,:);

end

function retImg=integralImage2D(I)
[nr,nc,nb]=size(I);
retImg=zeros(nr,nc,nb);
retImg(1,:,:)=I(1,:,:);
for i=2:nr
    retImg(i,:,:)=retImg(i-1,:,:)+I(i,:,:);
end
%vtuneResumeMex;
for j=2:nc
    retImg(:,j,:)=retImg(:,j-1,:)+retImg (:,j,:);
end
%vtunePauseMex;
end
