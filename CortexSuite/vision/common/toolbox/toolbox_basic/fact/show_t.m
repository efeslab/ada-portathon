function show_t(t)

frames = 0.5*length(t);

ts = reshape(t,frames,2);

plot(ts(:,1),ts(:,2));
hold on
plot(ts(:,1),ts(:,2),'rx');
hold off;
