function retImgs=readData(imgName, dataDir)
fn=fullfile(dataDir, imgName, '*.jpg');
filelist=dir(fn);

retImgs=cell(length(filelist),1);
for i=1:length(filelist)
    retImgs{i}=imread(fullfile(dataDir, imgName, filelist(i).name));
end

