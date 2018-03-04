function show_t(t)

frames = length(t)/3;

ts = reshape(t,frames,3);

plot3(ts(:,1),ts(:,2),ts(:,3));
hold on
plot3(ts(:,1),ts(:,2),ts(:,3),'rx');
hold off;
