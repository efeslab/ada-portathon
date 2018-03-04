function h2d = hist_f(Ifs,f1,s1,f2,s2)


binf = [-30:2.5*2:30];


%%% make 2d histogram bin

If1 = Ifs(:,:,f1,s1);
If2 = Ifs(:,:,f2,s2);
h2d = [];

binf(1) = -100;
binf(length(binf)) = 100;

for j = 2:length(binf),

  [id_i,id_j] = find((If1>binf(j-1)) & (If1<=binf(j)));
  if (length(id_i) >0),
    
    h = hist(If2(id_i+(id_j-1)*size(If2,1)),binf);
  else
    h = zeros(size(binf));
  end


  h2d = [h2d,h'];
end
