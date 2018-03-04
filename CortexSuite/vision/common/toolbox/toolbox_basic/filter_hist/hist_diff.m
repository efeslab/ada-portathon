function hdiff = hist_diff(H1,H2)
%
%  hdiff = hist_diff(H1,H2)
%

ns = size(H1,3);
nf = size(H1,4);

sI= [1,0,1];sI = exp(-sI);
sI = sI/sum(sI);

hdiff = 0;
for j = 1:ns,
  for k = 1:nf,
	h1 = H1(:,:,j,k);
        h2 = H2(:,:,j,k);

	h1s = conv2(conv2(h1,sI','same'),sI,'same');  
        h2s = conv2(conv2(h2,sI','same'),sI,'same');  

	[is,js] = find( (h1>0) | (h2>0));
        ids = (js-1)*size(h1,1) + is;

        xdiffs = ((h1s(ids)-h2s(ids)).*(h1s(ids)-h2s(ids)))./(h1s(ids)+h2s(ids));
	hdiff = hdiff + sum(xdiffs);

   end
end

hdiff = hdiff/(ns*nf);
