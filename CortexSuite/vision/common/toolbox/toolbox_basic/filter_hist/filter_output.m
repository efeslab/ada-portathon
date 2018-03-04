function If = filter_output(I,sigs,szs,flag);
%
%  compute filter output for all orientation and scale,
%

%% flag = 1 if compute oriented filter output
if (~exist('flag')),
  flag = 1;
end


If = [];

for j = 1:length(sigs),
   sig = sigs(j);
   sz = 2*round(4*sig)+1;

   g = mkdog1(sig,sz);
   fprintf('[');
   fprintf('.');
   If(:,:,1,j) = conv2(I,g,'same');

   angles = [0:30:150];
   r = 3;

   if flag,
   for k = 1:length(angles),
     fprintf('.');
     g = mdoog2(sig,r,angles(k),szs(j));
     If(:,:,k+1,j) = conv2(I,g,'same');
   end
   end

   fprintf(']');

end

fprintf('\n');