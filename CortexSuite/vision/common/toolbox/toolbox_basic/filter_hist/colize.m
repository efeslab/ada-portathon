function t1a = colize(t1,I1);

t1a = t1;

t1a = reshape(t1a,size(t1,1)*size(t1,2),1,size(t1,3));
t1a = squeeze(t1a);
t1a = t1a';

%I1a = 2*I1(:)';I1a = I1a-mean(I1a(:));t1a = [I1a;t1a];
