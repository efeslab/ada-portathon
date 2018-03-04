
%fnames = dir('/home/jshi/Results_DLIB/SegLabl*.mat');

fnames = dir('/data/jshi/DLIB/Results/Results_DLIB/SegLabl*.mat');

for j=1:length(fnames),
	cm = sprintf('load /data/jshi/DLIB/Results/Results_DLIB/%s',fnames(j).name);
        disp(cm);eval(cm);
figure(1);imagesc(I); colormap(gray); axis image;
figure(2); imagesc(SegLabel); axis image;

pause;
end
