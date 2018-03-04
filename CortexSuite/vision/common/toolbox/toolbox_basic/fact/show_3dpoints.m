function show_3dpoints(S)


for j=1:size(S,2),
  x = S(1,j);
  y = S(2,j);
  z = S(3,j);
  plot3(x,y,z,'*');
  hold on;
  plot3([x,0],[y,0],[z,0],'r');
%  plot3([x,x],[y,y],[z,0],'r');
%  plot3([x,0],[y,y],[z,z],'r'); plot3([x,x],[y,0],[z,z],'r');
  text(x,y,z,int2str(j))
%  plot3(x,y,0,'co');
end

grid on
xlabel('x');
ylabel('y');
zlabel('z');

hold off