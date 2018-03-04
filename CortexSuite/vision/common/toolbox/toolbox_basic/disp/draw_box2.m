function draw_box(center,w_h,j)


center_x = center(1);
center_y = center(2);

%plot(center_x,center_y,'r*');
%text(center_x,center_y,int2str(j));

l_x = center_x-w_h(1);
r_x = center_x+w_h(1);
u_y = center_y-w_h(2);
l_y = center_y+w_h(2);

plot([l_x,r_x,r_x,l_x,l_x],[u_y,u_y,l_y,l_y,u_y],'c');


