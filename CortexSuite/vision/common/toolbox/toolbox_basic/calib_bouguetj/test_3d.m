Rc_1 = rodrigues(omc_1);
Rc_2 = rodrigues(omc_2);
Rc_3 = rodrigues(omc_3);
Rc_4 = rodrigues(omc_4);
Rc_5 = rodrigues(omc_5);
Rc_6 = rodrigues(omc_6);
Rc_7 = rodrigues(omc_7);
Rc_8 = rodrigues(omc_8);
Rc_9 = rodrigues(omc_9);

Rc_10 = rodrigues(omc_10);
Rc_11 = rodrigues(omc_11);
Rc_12 = rodrigues(omc_12);
Rc_13 = rodrigues(omc_13);
Rc_14 = rodrigues(omc_14);
Rc_15 = rodrigues(omc_15);
Rc_16 = rodrigues(omc_16);
Rc_17 = rodrigues(omc_17);
Rc_18 = rodrigues(omc_18);



RR1 = Rc_1'*Rc_10; % should be rodrigues([0;pi/2;0])
TT1 = Rc_1'*(Tc_10-Tc_1); % should be [dX*n_sq_x_1;0;0]

Xr_1 = RR1 * X_10  + TT1*ones(1,length(X_10));

figure(1);
plot3(X_1(1,:),X_1(2,:),X_1(3,:),'r+'); hold on;
plot3(Xr_1(1,:),Xr_1(2,:),Xr_1(3,:),'g+');
hold off;
axis('equal');
rotate3d on;
view(0,0);
xlabel('x');
ylabel('y');
zlabel('z');

aaa = [];

RR1 = Rc_1'*Rc_10; % should be rodrigues([0;pi/2;0])
TT1 = Rc_1'*(Tc_10-Tc_1); % should be [dX*n_sq_x_1;0;0]
err = rodrigues(RR1) - [0;pi/2;0]
aaa = [aaa 2*sin(err(2)/2)*.33*1000];

RR2 = Rc_2'*Rc_11; % should be rodrigues([0;pi/2;0])
TT2 = Rc_2'*(Tc_11-Tc_2); % should be [dX*n_sq_x_1;0;0]
err = rodrigues(RR2) - [0;pi/2;0]
aaa = [aaa 2*sin(err(2)/2)*.33*1000];

RR3 = Rc_3'*Rc_12; % should be rodrigues([0;pi/2;0])
TT3 = Rc_3'*(Tc_12-Tc_3); % should be [dX*n_sq_x_1;0;0]
err = rodrigues(RR3) - [0;pi/2;0]
aaa = [aaa 2*sin(err(2)/2)*.33*1000];

RR4 = Rc_4'*Rc_13; % should be rodrigues([0;pi/2;0])
TT4 = Rc_4'*(Tc_13-Tc_4); % should be [dX*n_sq_x_1;0;0]
err = rodrigues(RR4) - [0;pi/2;0]
aaa = [aaa 2*sin(err(2)/2)*.33*1000];

RR5 = Rc_5'*Rc_14; % should be rodrigues([0;pi/2;0])
TT5 = Rc_5'*(Tc_14-Tc_5); % should be [dX*n_sq_x_1;0;0]
err = rodrigues(RR5) - [0;pi/2;0]
aaa = [aaa 2*sin(err(2)/2)*.33*1000];

RR6 = Rc_6'*Rc_15; % should be rodrigues([0;pi/2;0])
TT6 = Rc_6'*(Tc_15-Tc_6); % should be [dX*n_sq_x_1;0;0]
err = rodrigues(RR6) - [0;pi/2;0]
aaa = [aaa 2*sin(err(2)/2)*.33*1000];

RR7 = Rc_7'*Rc_16; % should be rodrigues([0;pi/2;0])
TT7 = Rc_7'*(Tc_16-Tc_7); % should be [dX*n_sq_x_1;0;0]
err = rodrigues(RR7) - [0;pi/2;0]
aaa = [aaa 2*sin(err(2)/2)*.33*1000];

RR8 = Rc_8'*Rc_17; % should be rodrigues([0;pi/2;0])
TT8 = Rc_8'*(Tc_17-Tc_8); % should be [dX*n_sq_x_1;0;0]
err = rodrigues(RR8) - [0;pi/2;0]
aaa = [aaa 2*sin(err(2)/2)*.33*1000];

