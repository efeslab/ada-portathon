function [retTStamp, retType, retData, retEOF, index]=readSensorData(index1, fid)

index = index1+1;
rows = size(fid, 1);
retTStamp = 0;
retType = 0;
retData = zeros(1,8);

if(index > rows)
    retEOF = 1;
else
%     for i=index:rows
%         index = i;
%         if(fid(i,2) == 4)
%             break;
%         end
%     end
    if(index == rows)
        retEOF = 1;
    else
        retEOF = 0;
    end

    k = index;
    retTStamp=fid(k,1);
    retType=fid(k,2);
    if(fid(k, 2) == 1 || fid(k, 2) == 2 || fid(k, 2) == 3)
        index = k;
        for i=1:3
            retData(1,i)=fid(k,i+2);
%            fprintf(1,'retData,i -> %f\t%d\n', retData(1,i), i);
        end
    end
    if(fid(k, 2) == 4)
        index = k;
        for i=1:3
            retData(1,i)=fid(k,i+2);
%            fprintf(1,'retData,i -> %f\t%d\n', retData(1,i), i);
        end
        for i=4:8
            retData(1,i) = fid(k+1,i-3);
%            fprintf(1,'retData,i -> %f\t%d\n', retData(1,i), i);
        end
        index = index + 1;        
    end    
end
