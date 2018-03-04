function [newFPnt, valid] = calcPyrLKTrack(iP, iDxP, iDyP, jP, fPnt, nFeatures, winSize, accuracy_th, max_iter)
	
cellDims = size(iP);
GOOD_FEATURE_LAMBDA_TH = accuracy_th;

for i=1:(cellDims(1))
    curImgDims = size(iP{i});
  	imgDims(i,1)= curImgDims(1);
  	imgDims(i,2)= curImgDims(2);

end

pLevel = cellDims(1);

rate=[1, 0.5, 0.25, 0.125, 0.0625, 0.03125];
winSizeSq=4*winSize*winSize;
iPatch=cell(1, winSizeSq);
jPatch=cell(1, winSizeSq);
iDxPatch=cell(1,winSizeSq);
iDyPatch=cell(1,winSizeSq);

valid(1:nFeatures) = 1;
newFPnt = zeros(2,nFeatures);

for i=1:nFeatures

    dX=0;
    dY=0;

%% x is rows here and y is cols
    
    x=fPnt(1,i)*rate(pLevel+1);                 %half size of real level
    y=fPnt(2,i)*rate(pLevel+1);

    for level=pLevel:-1:1

        x = x+x;
        y = y+y;
        dX = dX+dX;
        dY = dY+dY;
        imgSize(1)=imgDims(level,1); %y,x		
        imgSize(2)=imgDims(level,2); %y,x		

        c_xx = 0;
        c_xy = 0;
        c_yy = 0;
            
        %when feature goes out to the boundary.

        if ((x-winSize)<1 || (y-winSize)<1 || (y+winSize+1)>imgSize(1) || (x+winSize+1)>imgSize(2))
            %winSize+1due to interpolation
            %error or skip the level??
            valid(i) = 0;
            break;
        end

        
        iPatch = getInterpolatePatch(iP{level}, imgSize(1), imgSize(2), x, y, winSize);
        iDxPatch = getInterpolatePatch(iDxP{level}, imgSize(1), imgSize(2), x, y, winSize);
        iDyPatch = getInterpolatePatch(iDyP{level}, imgSize(1), imgSize(2), x, y, winSize);

        for idx=1:winSizeSq
            c_xx = c_xx + iDxPatch(idx) * iDxPatch(idx);
            c_xy = c_xy + iDxPatch(idx) * iDyPatch(idx);
            c_yy = c_yy + iDyPatch(idx) * iDyPatch(idx);
        end

        c_det = c_xx * c_yy - c_xy * c_xy;
        
        if (c_det/(c_xx+c_yy+0.00001)) < GOOD_FEATURE_LAMBDA_TH
            valid(i)=0;
            break;
        end

        c_det=1/c_det;

        for k=1:max_iter
            if ((x+dX-winSize)<1 || (y+dY-winSize)<1 || (y+dY+winSize+1)>imgSize(1) || (x+dX+winSize+1)>imgSize(2))
                %winSize+1due to interpolation
                %error or skip the level??
                valid(i)=0;
                break;
            end

            jPatch = getInterpolatePatch(jP{level}, imgSize(1), imgSize(2), x+dX, y+dY, winSize);
            eX = 0;
            eY = 0;
            for idx=1:winSizeSq
                dIt = iPatch(idx) - jPatch(idx);
                eX = eX + (dIt*iDxPatch(idx));
                eY = eY + (dIt*iDyPatch(idx));
            end

            mX = c_det*(eX*c_yy-eY*c_xy);
            mY = c_det*(-eX*c_xy+eY*c_xx);
            dX = dX + mX;
            dY = dY + mY;


            if ((mX*mX+mY*mY)<accuracy_th)
                break;
            end
        end
    end
    
    newFPnt(1, i) = fPnt(1,i)+dX;
    newFPnt(2, i) = fPnt(2,i)+dY;
end
