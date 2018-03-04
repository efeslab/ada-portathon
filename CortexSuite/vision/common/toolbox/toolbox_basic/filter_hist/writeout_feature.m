function writeout_feature(I,tex,fname,I_max,tex_max)
%
%   writeout_feature(I,tex,fname,I_max,tex_max)
%
%


%%%%% print out image 
I_min = min(I(:));

I = I-I_min;
I = min(1,I/(I_max-I_min));

I = 2*I-1;

j = 0;
fn = sprintf('%s_%d.pfm',fname,j);
cm = sprintf('writepfm: I->%s',fn);
disp(cm);
writepfm(fn,I);


%%% print out texture
nf = size(tex,3)

for j=1:nf,
  
  fn = sprintf('%s_%d.pfm',fname,j);
  cm = sprintf('writepfm:tex_%d->%s',j,fn);
  disp(cm);

tex(:,:,j) = tex(:,:,j)/tex_max;fprintf('.');
tex(:,:,j) = tex(:,:,j).*(tex(:,:,j)<=1) + 1*(tex(:,:,j)>1);fprintf('.')
tex(:,:,j) = tex(:,:,j).*(tex(:,:,j)>=-1) + (-1)*(tex(:,:,j)<-1);fprintf('.');

  writepfm(fn,tex(:,:,j));


end

