function disp_diff(H1,H2)
%
%  disp_diff(H1,H2)
%

ns = size(H1,3);
nf = size(H1,4);

H1 = H1/49;
H2 = H2/49;


sI= [1,0,1];sI = exp(-sI);
sI = sI/sum(sI);

for j = 1:ns,
  for k = 1:nf,
	h1 = H1(:,:,j,k);
        h2 = H2(:,:,j,k);

        subplot(ns,nf,(j-1)*nf+k);
	h1s = conv2(conv2(h1,sI','same'),sI,'same');  
        h2s = conv2(conv2(h2,sI','same'),sI,'same');  

	[is,js] = find( (h1>0) | (h2>0));
        ids = (js-1)*size(h1,1) + is;

	hdiff = abs(h1s-h2s).*((h1>0) | (h2>0));

	xdiff = ((h1(ids)-h2(ids)).*(h1(ids)-h2(ids)))./(h1(ids)+h2(ids));

        xdiffs = ((h1s(ids)-h2s(ids)).*(h1s(ids)-h2s(ids)))./(h1s(ids)+h2s(ids));
        imagesc(hdiff);colorbar;axis('off');
%        title(sprintf('%3.3f, %3.3f',sum(sum(hdiff))/49,sum(sum(abs(h1-h2)))/49));drawnow;
        title(sprintf('%3.3f, %3.3f',sum(xdiff),sum(xdiffs)));drawnow
   end
end
