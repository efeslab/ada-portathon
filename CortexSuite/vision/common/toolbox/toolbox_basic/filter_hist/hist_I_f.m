function h2d = hist_I_f(I,If,binI,binf)

if (nargin == 2),
  binI = [0:13:260];
  binf = [-30:2.5*2:30];
end

%%% make 2d histogram bin
h2d = [];

for j = 2:length(binf),

  [id_i,id_j] = find((If>binf(j-1)) & (If<=binf(j)));
  if (length(id_i) >0), 
    h = hist(I(id_i+(id_j-1)*size(I,1)),binI);
  else
    h = zeros(size(binI));
  end

  h2d = [h2d,h'];
end

