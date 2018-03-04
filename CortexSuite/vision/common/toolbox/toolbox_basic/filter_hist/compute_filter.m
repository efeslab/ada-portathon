function [filter_output,filters] = compute_filter(I,sig,r,sz);
%
%
%

ori_incr=180/num_ori;
ori_offset=ori_incr/2; % helps with equalizing quantiz. error across filter set

as = ori_offset:ori_incr:180+ori_offset-ori_incr;

filter_output = [];
filters = [];

wsz = 2*round(sz) + 1;
M1 = wsz(1);M2 = wsz(2);

%%%%% prepare FFT of image  %%%%%%%%%%%%%

[N1,N2]=size(I);
tmp=zeros(size(I)+[M1-1 M2-1]);
tmp(1:N1,1:N2)=I;
IF=fft2(tmp);


%%%%%%%%%% filtering stage %%%%%%%%%%%
if size(sig,2)== 1,

  for j = 1:length(as),
    fprintf('.');
    angle = as(j);

    g = mdoog2(sig,r,angle,round(sz));

    g = g - mean(reshape(g,prod(size(g)),1));

    g = g/sum(sum(abs(g)));

    filters(:,:,j) = g;

    gF  = fft2(g,N1+M1-1,N2+M2-1);
    IgF = If.*gF;
    Ig  = real(ifft2(IgF));
    Ig  = Ig(ceil((M1+1)/2):ceil((M1+1)/2)+N1-1,ceil((M2+1)/2):ceil((M2+1)/2)+N2-1);
   
    %c = conv2(I,g,'valid');

    filter_output(:,:,j) = Ig;
  end
else

  % there are multiple scales
  sigs = sig;
  szs = sz;
  for k = 1:size(sigs,2),
     sig = sigs(k);
     sz = szs(k);
     fprintf('%d',k);
     for j = 1:length(as),
    	fprintf('.');
    	angle = as(j);

    	g = mdoog2(sig,r,angle,round(sz));
	g = g - mean(reshape(g,prod(size(g)),1));
	g = g/sum(sum(abs(g)));

	gF  = fft2(g,N1+M1-1,N2+M2-1);
    	IgF = If.*gF;
    	Ig  = real(ifft2(IgF));
    	Ig  = Ig(ceil((M1+1)/2):ceil((M1+1)/2)+N1-1,ceil((M2+1)/2):ceil((M2+1)/2)+N2-1);
   
        %c = conv2(I,g,'valid');
        %c = conv2(I,g,'same');

	filter_output(:,:,j,k) = Ig;
 	filters(:,:,j,k) = g; 
     end


  end

end

fprintf('\n');

