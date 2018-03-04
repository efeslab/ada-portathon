sigs = [1/sqrt(2),1,sqrt(2),2,2*sqrt(2)];r = 3;szs = round(r*3*sigs);

load filenames;

nfiles = size(filename,1);

for j = 48:nfiles,
   fname = ['images/',filename(j,:)];
   fname
   I = readpgm(fname);

   text_des = compute_filter(I,sigs,r,szs);

   data_name = sprintf('filter_%s.mat',filename(j,:));
   cm = sprintf('save %s ',data_name);

   disp(cm);
   eval(cm);
   clear;
   
   sigs = [1/sqrt(2),1,sqrt(2),2,2*sqrt(2)];r = 3;szs = round(r*3*sigs);

   load filenames;

   nfiles = size(filename,1);

   
end

