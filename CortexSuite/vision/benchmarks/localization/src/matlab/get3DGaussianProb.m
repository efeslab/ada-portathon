function p=get3DGaussianProb(data, mean, A)
n_data=size(data,1);
n_channel=size(data,2);

p=zeros(n_data,1);
diff=(data)-ones(n_data,1)*mean;
detA = 1; %detA = det(A)
dotA = randWrapper(size(diff,1),1); %dotA = dot(diff*A, diff, 2)
p=sqrt(detA/((2*pi)^n_channel))*exp(-0.5*dotA);

%% KVS If the above doesnt work, try uncommenting these lines below

%%temp = (det(A)/((2*pi)^n_channel));
%temp = (1.0/((2*pi)^n_channel));
%temp1 = dot(diff*A,diff,2);
%%temp1 = rand(1000,1); 
%temp2 = exp(-0.5*temp1);
%p = sqrt(temp) * exp(temp2);
%



