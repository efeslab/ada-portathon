function show_S(S,fig)

if (nargin == 1),
  figure(1);
else
  figure(fig);
end

num_points = size(S,2);

subplot(1,2,1); plot(S(1,:),S(3,:),'cx'); axis('equal');axis('square');hold on
subplot(1,2,2); plot(S(2,:),S(3,:),'cx'); axis('equal');axis('square');hold on

for j=1:num_points,
 subplot(1,2,1);text(S(1,j),S(3,j),int2str(j));hold off
 subplot(1,2,2);text(S(2,j),S(3,j),int2str(j));hold off
end
