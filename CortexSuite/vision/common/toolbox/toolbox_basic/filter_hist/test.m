
fn = '130065'; nr = 30;nc = 49;
%nr = 49;nc = 30;
%nc = 68;nr = 43;
%nr =49;nc = 30;

basedir = 'plaatje_data/newdata/';
if 1,
fname = sprintf('%s%s_eigvec.pfm',basedir,fn);
eigv =  readpfm(fname);
fname = sprintf('%s%s_eigval.pfm',basedir,fn);
eigval = readpfm(fname);

fname = sprintf('%s%s_ncutvec.pfm',basedir,fn);
ncutv = readpfm(fname);
fname = sprintf('%s%s_ncutval.pfm',basedir,fn);
ncutval = readpfm(fname);
else
fname = sprintf('%sncutvec_%s.pfm',basedir,fn);
ncutv = readpfm(fname);
fname = sprintf('%sncutval_%s.pfm',basedir,fn);
ncutval = readpfm(fname);
end


fname = sprintf('images/%s.pgm',fn);
I = readpgm(fname);
cutsz = 20; I = cutoff(I,cutsz);
figure(3);im(I);colormap(gray);

figure(6);
for j=1:min(8,size(ncutv,2)-1),
  subplot(3,3,j);
  im(reshape(ncutv(:,j+1),nr,nc));colorbar
  title(num2str(ncutval(j+1,1)));
end
%cm = sprintf('print -dps ncut_%s',fn);disp(cm);eval(cm);
subplot(3,3,9);im(I);axis('off');

ev = eigval(:,1);
figure(5);hold off;clf;subplot(1,2,1);
%semilogy((ev(1:end-1) - ev(2:end))./ev(1:end-1),'x-');grid on;
plot((ev(1:end-1) - ev(2:end))./ev(1:end-1),'x-');grid on;
%semilogy(0.01*ones(size(ev(2:end-1))),'r-');semilogy(0.005*ones(size(ev(2:end-1))),'r-');semilogy(0.0025*ones(size(ev(2:end-1))),'r-');grid on;hold off;
subplot(1,2,2);
%semilogy(ev(1:end-1)-ev(2:end),'p-');grid on;
semilogy((ev(1:end-1) - ev(2:end))/ev(1),'x-');grid on;


ncutv_o = ncutv;

recursive_cut_tc;

%[groups,ids] = recursive_cut(ncutv(:,1:4),fn);

masks = make_masks(groups,ids,nr,nc);

cm = sprintf('save masks_%s masks ncutv_o groups ids nr nc',fn);
disp(cm);

eval(cm);


%%%%%%%%%%%%%%%%%%
fn = '130040';
cm = sprintf('load masks_%s',fn);
disp(cm);
eval(cm);

fn = '130040';
fname= sprintf('images/%s.pgm',fn);
I = readpgm(fname);cutsz = 20; I = cutoff(I,cutsz);
figure(3);im(I);colormap(gray);
hw = 2; %nr = 43;nc=68;
gap = 2*hw+1;
%nr = 30;nc=49;
Is = I(1:nr*gap,1:nc*gap);
figure(3);im(Is);axis('off');

%cm = sprintf('print -deps I_%s',fn);disp(cm);eval(cm);



%masks = make_masks(groups,ids,nr,nc);
figure(2);disp_groups(groups,ids,nr,nc);

figure(1);
Imasks = disp_Imask(Is,nr,nc,hw,masks);

for j=1:length(ids),
 figure(4);colormap(gray);clf
 im(Imasks(:,:,j));axis('off');
 cm = sprintf('print -deps result_cut_%s_%d',fn,j);
 disp(cm);eval(cm);

 %print -deps result_cut_134011_1
end


if 0,

%load st_134013

fn = '134013_t';

I_max = 250;
tex_max = 40;

writeout_feature(I1,T1,fn,I_max,tex_max);
end
