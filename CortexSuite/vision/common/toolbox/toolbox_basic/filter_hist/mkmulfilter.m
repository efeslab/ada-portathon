function H = make_multi_filter(templates,num_templates,sze,u,noise)
%  function H = make_filter(templates,num_templates,sze,u,noise)
%     templates are column vectors of template
%     sze is the size of the filter  
%     u is a vector of specified value
%  
%

templates_size_x = size(templates,2)/num_templates;
templates_size_y = size(templates,1);

alpha = 1/num_templates;

X = zeros(num_templates,sze(1)*sze(2));
Spectrums = zeros(num_templates,sze(1)*sze(2));


for k =1:num_templates,
   tmp = zeros(sze);
   tmp(1:templates_size_y,1:templates_size_x) =...
     templates(:,(k-1)*templates_size_x+1:k*templates_size_x);
   x(k,:) = reshape(tmp,1,sze(1)*sze(2));	
   X(k,:) = fft(x(k,:));
   Spectrums(k,:) = conj(X(k,:)).*X(k,:);
end

if num_templates > 1
 sum_Spect = sum(Spectrums)*alpha;
else
 sum_Spect = Spectrums;
end

for row = 1:num_templates,
  for column = 1:num_templates,

     A(row,column) =  sum( ((conj(X(row,:)).*X(column,:))./...
                           (sum_Spect + noise))')/(sze(1)*sze(2));
  end
end


epsilon = inv(A)*u;

top = epsilon(1)*X(1,:);
for k = 2:num_templates,
  top = top + epsilon(k)*X(k,:);
end

H = top./(sum_Spect + noise);



