function draw_box(left,right,top,down)

plot([left,right],[top,top]);
hold on
plot([left,right],[down,down]);
hold on
plot([left,left],[top,down]);
hold on
plot([right,right],[top,down]);