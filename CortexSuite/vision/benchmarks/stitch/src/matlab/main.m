Icur_list=readData('capitol');
Icur=Icur_list{1};
%Icur=Icur(1:150,:,:);
[x y v]=harris(Icur);
interestPntsCur=getANMS(x, y, v, 24);
Fcur=extractFeatures(Icur, interestPntsCur(:,1), interestPntsCur(:,2));

for id=2:length(Icur_list)
    Iprev=Icur;
    Fprev=Fcur;
    interestPntsPrev=interestPntsCur;
    Icur=Icur_list{id};
    %Icur=Icur(1:150,:,:);
    [x y v]=harris(Icur);
    %showInterestPoints(I, x, y)
    interestPntsCur=getANMS(x, y, v, 16);
    %showInterestPoints(I, interestPnts(:,1), interestPnts(:,2))
    Fcur=extractFeatures(Icur, interestPntsCur(:,1), interestPntsCur(:,2));
    matchedPntsIdx=matchFeatures(Fprev, Fcur);
    matchedPntsPrev=interestPntsPrev(matchedPntsIdx(:,1),:);
    matchedPntsCur=interestPntsCur(matchedPntsIdx(:,2),:);
    
    %subplot(1,2,1);showInterestPoints(Iprev, matchedPntsPrev(:,1), matchedPntsPrev(:,2));axis image
    %subplot(1,2,2);showInterestPoints(Icur, matchedPntsCur(:,1), matchedPntsCur(:,2));axis image
    %drawnow
    %pause;
    %printImage(['featureMatching' int2str(id-1) '_' int2str(id)]);
    [retH retPntsIdx]=ransac(matchedPntsPrev, matchedPntsCur, 10000, 100);  
    subplot(2,2,1);showInterestPoints(Iprev, matchedPntsPrev(retPntsIdx,1), matchedPntsPrev(retPntsIdx,2));axis image
    subplot(2,2,2);showInterestPoints(Icur, matchedPntsCur(retPntsIdx,1), matchedPntsCur(retPntsIdx,2));axis image
    T=maketform('projective', retH');
    Tfn_Mat=T;
    [nr nc nd]=size(Iprev);
    Itrans=imtransform(Iprev,T,'XData', [1 nc], 'YData', [1 nr],'FillValues',[0;0;0]);
    subplot(2,2,3);imshow(Itrans)    
    subplot(2,2,4);imagesc(rgb2gray(abs(Icur-Itrans)))
    drawnow
    pause;
    printImage(['ransac' int2str(id-1) '_' int2str(id)]);
end

    %[Itrans2 XData YData]=imtransform(Iprev,T,'FillValues',[0;0;0]);
    %for the fast iteration
    %[Itrans2 XData2 YData2]=imtransform(Iprev,T,'XData', [-2*nc 2*nc], 'YData', [-2*nr 2*nr],'FillValues',[0;0;0]);

    %h=imshow(Itrans);

