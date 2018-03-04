function t1a = colize(t1,I1);

if 1,
t1a = t1;
%t1a = 1.2*half_sigmoid(t1,0.3,0.1);;
t1a = reshape(t1a,size(t1,1)*size(t1,2),1,size(t1,3));
t1a = squeeze(t1a);
t1a = t1a';

%I1a = I1(:)';I1a = I1a-mean(I1a(:));t1a = [I1a;t1a];

else
  mask = t1>=0;
  t1a = abs(t1);
  t1a = 0.5-t1a;
  t1a = reshape(t1a,size(t1,1)*size(t1,2),1,size(t1,3));
  t1a = squeeze(t1a);
  t1a = t1a';
end
