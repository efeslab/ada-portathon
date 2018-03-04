function montage2(FI)
% montage2(FI)
% display 3D stack of images in a montage

[N1,N2,N3]=size(FI);
Q=zeros(N1,N2,1,N3);
for n=1:N3
   Q(:,:,1,n)=FI(:,:,n);
end

a=min(Q(:));
b=max(Q(:));

Q=Q-a;
Q=Q/(b-a);

montage(Q);