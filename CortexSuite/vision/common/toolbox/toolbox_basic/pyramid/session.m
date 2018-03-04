%image_dir = '/home/barad-dur/d/malik/jshi/';
%I = gifread([image_dir,'tape9/t9a1_L.40.gif']);
I = pgmread('car100x100_0001');
Io = I;

B = [];

done = 0;
st = 2;
sz = size(I);
while (~done),
   w = max(1,round(0.05*size(I,1)));
   b = zeros(round(0.5*size(Io)),round(0.5*size(I)));
   %J = smooth(I,w);
   %I = J(1:st:size(J,1),1:st:size(J,2));
   I = reduce(I);
   sz = [sz;size(I)];
   b(1:size(I,1),1:size(I,2)) = I;
   disp(int2str(size(I,1)));

   B = [B,b];

   if (size(I,1) < 8),
    done = 1;
   end
end
