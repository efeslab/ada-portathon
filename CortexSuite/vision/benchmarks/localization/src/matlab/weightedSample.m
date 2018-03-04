%function x_gen_id=weightedSample(w)
function bin=weightedSample(w)
n=size(w,1);
seed=randWrapper(n,1);
bin = zeros(n,1);
%x_gen_id=zeros(n,1);
 for i=1:n
     for j=1:n
         if(seed(j,1) > 0)
             bin(j,1) = bin(j,1) + 1;
%             x_gen_id(j,1) = x_gen_id(j,1) + bin(j,1);
         end
     end
%     bin = (seed>0);
%     x_gen_id=x_gen_id+bin;
     seed=seed-w(i,1);
 end
% x_gen_id = bin;
%x_gen=x(:,x_gen_id);

