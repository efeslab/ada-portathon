function [T,A,M2,TAM]=showsmm(L1,L2,phi,maxM);
% [T,A,M]=showsmm(L1,L2,phi,maxM);

if (~exist('maxM')),
% needs to know upper bound on M for given window function in smm
maxM=0.18; % temporary
end


A=1-L2./(L1+eps);
T=2*(phi+pi/2)/(2*pi);
M=L1+L2;
M2=min(M/maxM,1); % keep it from exceeding 1
%M2 = sigmoid(M,maxM,30);

matlab5on = 1;

if matlab5on == 1,
  TAM=hsv2rgb(T,A,M2);

  figure(3);
  image(TAM);
  axis('tightequal');
else
  H = [reshape(T,prod(size(T)),1),...
       reshape(A,prod(size(A)),1),...
       reshape(M2,prod(size(M2)),1)];
  M = hsv2rgb(H);
  [Ic,map] =vmquant(M(:,1),M(:,2),M(:,3),256);

  image(reshape(Ic,size(T,1),size(T,2)));colormap(map);
end

if 0
   plot3(A(:).*M(:).*cos(2*pi*T(:)),A(:).*M(:).*sin(2*pi*T(:)),M(:),'.','markersize',15)
   axis([-1 1 -1 1 0 1])
   [x,y,z] = cylinder(ones(1,5));
   x=x.*z;
   y=y.*z;
   hold on
   h=mesh(x,y,z);
   set(h,'edgecolor',[.2 .2 .2]);
   hidden off
   hold off
end