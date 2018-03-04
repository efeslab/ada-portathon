%calcGoodFeature:

function [lambda, tr, det,c_xx, c_xy, c_yy] = calcGoodFeature(dX, dY, sizeX, sizeY, winSize, dataDir) 

    for i=1:sizeY
        for j=1:sizeX
    		xx(i,j)=dX(i,j)*dX(i,j);
        	xy(i,j)=dX(i,j)*dY(i,j);
            yy(i,j)=dY(i,j)*dY(i,j);
        end
    end
    
	c_xx=calcAreaSum(xx, sizeX, sizeY, winSize,dataDir);
    c_xy=calcAreaSum(xy, sizeX, sizeY, winSize,dataDir);
	c_yy=calcAreaSum(yy, sizeX, sizeY, winSize,dataDir);
 
	for i=1:sizeY
        for j=1:sizeX
    		tr(i,j)= c_xx(i,j)+c_yy(i,j);
        	det(i,j)= c_xx(i,j)*c_yy(i,j)-c_xy(i,j)*c_xy(i,j);
%             if( tr(i,j) == 0 )
%                 lambda(i,j) = 0;
%             else
                lambda(i,j)=det(i,j)/(tr(i,j) + 0.00001);
%            end
        end
    end
 
