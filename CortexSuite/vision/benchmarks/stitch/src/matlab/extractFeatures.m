function vecF=extractFeatures(I, x, y, dataDir)

Igray = I;
w = (1/16)*[1 4 6 4 1];
[n temp]=size(x);

%SUB sample rate s=5
wt = w';
Iconv=conv2(w, wt, Igray, 'same');
Iconv=conv2(w, wt, Iconv, 'same');
Isub=Iconv(1:5:end,1:5:end);
[nr nc]=size(Isub);
    
Xsub=min(floor(x/5)+1, nc-4);
Ysub=min(floor(y/5)+1, nr-4);

if(length(Xsub) < 6 || length(Ysub) < 10)
    vecF = [Xsub Ysub];
    return;
end

newSize = 4;
[rows, cols] = size(I);
if(rows > 32 & cols >32)
    newSize = 64;
end

for i=1:n

    minValy = 3;
    minValx = 3;
    if( Ysub(i) < 4)
        Ysub(i) = 4;
    end
    if( Xsub(i) < 4)
        Xsub(i) = 4;
    end

    if( Ysub(i) > size(Isub,1)-4)
        Ysub(i) = size(Isub,1)-4;
    end
    if( Xsub(i) > size(Isub,2)-4)
        Xsub(i) = size(Isub,2)-4;
    end
    
    vecF(i,:)=reshape(Isub(Ysub(i)-minValy:Ysub(i)+4,Xsub(i)-minValx:Xsub(i)+4),1,newSize);

    %normalization
    vecF(i,:)=vecF(i,:)-mean(vecF(i,:));
    vecF(i,:)=vecF(i,:)/std(vecF(i,:));
    %imagesc(reshape(vecF(i,:),8,8)); colormap gray
    %drawnow
    %pause    
end


