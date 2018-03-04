
I_max = 250;
tex_max = 30;

%fnames = [130038,130039,130042,130056,130057];
%fnames = [334074 334031 334044 334003 334065 334000 334039 334018 334002 334029]

fnames = 130057;

for j=1:length(fnames),
fname = sprintf('images/%d.pgm',fnames(j));

sigs = [1/sqrt(2),1,sqrt(2),2,2*sqrt(2)];r = 3;szs = round(r*3*sigs);  
szs = szs(length(szs))*ones(1,length(szs));
num_ori = 6;

I = readpgm(fname);
[text_des,filters] = compute_filter_fft(I,sigs,r,szs,num_ori); 

outname = sprintf('plaatje_data/%d',fnames(j));

cutsz =20;
I = cutoff(I,cutsz);%figure(1);im(I);
text_des = cutoff(text_des,cutsz);

writeout_feature(I,text_des(:,:,:),outname,I_max,tex_max);


if 0,
for j=0:30,
  cm = sprintf('!mv plaatje_data/134013.pfm_%d.pfm plaatje_data/134013_%d.pfm',j,j);
  disp(cm);eval(cm);
end
end

end

exit
