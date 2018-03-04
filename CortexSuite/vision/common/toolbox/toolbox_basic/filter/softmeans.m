function [cluster,var,mix,membership,lG] = softmeans(cluster0,var0,minvar,mix0,minmix,data)

[k,D] = size(cluster0);
[n,D] = size(data);
cluster_p = cluster0; var_p = var0; mix_p = mix0;
old_lg = -inf; lG = [];

for iter = 1:30, % max.iterations
  % E-Step + comp. incomplete likelihood

  H = zeros(n,k);
  for j = 1:k,
    Hj = (data-(ones(n,1)*cluster_p(j,:))).^2;
    if D > 1, Hj = sum(Hj')'; end
    H(:,j) = exp(Hj /(-2*var_p(j)))/(sqrt(var_p(j))^D);
  end
  H = H.*(ones(n,1)*mix_p');
  new_lg = sum(log(sum(H')/(sqrt(2*pi)^D)));
  lG = [lG, new_lg];
  if new_lg == old_lg, break; end; old_lg = new_lg;
  H = H./(sum(H')'*ones(1,k)); % normalize

  % M-Step:

  if minmix > 0,    
    mix_p = sum(H); mix_p = mix_p/sum(mix_p); mix_p = mix_p';
    for j = 1:k, if mix_p(j)<minmix, mix_p(j) = minmix; end; end;
  end
  cluster_p = (H./(ones(n,1)*sum(H)))'*data;
  if minvar > 0,
   for j = 1:k,
    varj = (data-(ones(n,1)*cluster_p(j,:))).^2;
    if D > 1, varj = sum(varj')'; end
    var_p(j) = sum(H(:,j).*varj)/(D*sum(H(:,j)));
    if var_p(j)<minvar, var_p(j) = minvar; end;
   end;
  end

%  cluster_p = cluster_p./(sqrt(sum(cluster_p'.^2)')*ones(1,D));
end

cluster = cluster_p;
var = var_p;
mix = mix_p;
membership = H;

