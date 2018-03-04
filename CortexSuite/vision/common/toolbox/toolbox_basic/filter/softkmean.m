function [cluster,var,mix,membership,lG] = softkmeans(data,k,cluster0)

[n,D] = size(data);
var = 1.0;
var0 = ones(k,1)*var; minvar = 0.0001;
mix0 = ones(k,1)/k; minmix = 0.0001;

k = size(var0,1);
[n,D] = size(data);

lGG = [];
ma = -1e20;
in = 0;

if (nargin == 2),
  max_data = max(data);
  min_data = min(data);
  %step = (max_data-min_data)/(k+1);
  %cluster0 = [1:k]'*step+min_data;
  mag = ones(k,1)*(max_data-min_data);
  base = ones(k,1)*min_data;
  cluster0 = rand(k,D).*mag + base;
end

%cluster0
for t = 1:3,
  %rndindx = round(rand(1,k)*(n-3))+2;
  %cluster0 = (data(rndindx,:)+data(rndindx+1,:)+data(rndindx-1,:))/2;
  [cluster,var,mix,membership,lG] = softmeans(cluster0,var0,minvar,mix0,minmix,data);
  eval(sprintf('mix_var_cluster_%d = [mix,var,cluster];',t));
  eval(sprintf('lG_%d = lG;',t));
  if ma<lG(size(lG,2)),
    ma = lG(size(lG,2));
    in = t;
  end

end

eval(sprintf('mix_var_cluster = mix_var_cluster_%d;',in));
eval(sprintf('lG = lG_%d;',in));
mix = mix_var_cluster(:,1);
var = mix_var_cluster(:,2);
cluster = mix_var_cluster(:,3:size(mix_var_cluster,2))


[tmp,vecs2cluster] = max(membership');
vecs2cluster = vecs2cluster';
cluster_iCV = inv(var);








