%calcAreaSum:
% sizeX = cols
% sizeY = rows
function ret = calcAreaSum(src, sizeX, sizeY, winSize, dataDir)

src = double(src);
nave = winSize;
nave_half = floor((nave+1)/2);
a1=zeros(1,sizeX+nave);
    
for i=1:sizeY
	%pull out one row
	for j=1:sizeX
		a1(j+nave_half)=src(i,j);
	end

	a1sum=0;
	%sum up values within a window
	for k=1:nave
		a1sum = a1sum+a1(k);
	end

	for j=1:sizeX
		ret(i,j) = a1sum;
		a1sum = a1sum + a1(j+nave) - a1(j);
	end
end

a1=zeros(1,sizeY+nave);
for i=1:sizeX

	%pull out one col
	for j=1:sizeY
		a1(j+nave_half)=ret(j,i);
	end

	a1sum=0;
	%sum up values within a window
	for k=1:nave
		a1sum = a1sum+a1(k);
	end

	for j=1:sizeY
		ret(j,i) = a1sum;
		a1sum = a1sum + a1(j+nave) - a1(j);
	end
end

