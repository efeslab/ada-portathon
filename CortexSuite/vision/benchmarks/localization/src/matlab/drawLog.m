function drawLog(data, ground_data)
subplot(1,3,1);
[nr nc]=size(data);
for i=1:nr
    x=data(i,2);
    y=data(i,3);
    z=data(i,4);
    R=[1 0 0; 0 cos(x) sin(x); 0 -sin(x) cos(x)]...
        *[cos(y) 0 -sin(y); 0 1 0; sin(y) 0 cos(y)]...
        *[cos(z) sin(z) 0; -sin(z) cos(z) 0; 0 0 1];
    coord=R*[1 0 0]';
    axis([-1 1 -1 1 -1 1]);axis on
    plot3([0 coord(1)], [0 coord(2)], [0 coord(3)], 'b'); hold on
end

[nr nc]=size(ground_data);
for i=1:nr
x=ground_data(i,2);
y=ground_data(i,3);
z=ground_data(i,4);
R=[1 0 0; 0 cos(x) sin(x); 0 -sin(x) cos(x)]...
        *[cos(y) 0 -sin(y); 0 1 0; sin(y) 0 cos(y)]...
        *[cos(z) sin(z) 0; -sin(z) cos(z) 0; 0 0 1];
coord=R*[1 0 0]';
coord2=R*[0 -1 0]';
axis([-1 1 -1 1 -1 1]);axis on
plot3([0 coord(1)], [0 coord(2)], [0 coord(3)], 'r'); hold on
plot3([0 coord2(1)], [0 coord2(2)], [0 coord2(3)], 'g');
end

xlabel('x');
ylabel('y');
zlabel('z');
hold off
drawnow
subplot(1,3,2);
Xoffset=4422610;
Yoffset=483660;
axis([4422610-Xoffset 4422660-Xoffset 483620-Yoffset 483720-Yoffset]);axis on
scatter(data(:,5)-Xoffset, data(:,6)-Yoffset, 8, 'b'); hold on
axis([4422610-Xoffset 4422660-Xoffset 483620-Yoffset 483720-Yoffset]);axis on
scatter(ground_data(:,5)-Xoffset, ground_data(:,6)-Yoffset, 10, 'r'); hold off
drawnow

