function retQuat=addEulNoise(quat, STD)
n=size(quat,1);

% KVS: replacing randnWrapper(n,3) with rand(n,3)
gyro=randnWrapper(n,3)*STD;

norm_gyro=sqrt(sum(gyro.^2,2));
angleAlpha=norm_gyro;
quatDelta=[cos(angleAlpha/2), gyro./(norm_gyro*ones(1,3)).*(sin(angleAlpha/2)*ones(1,3))];

retQuat=quatMul(quat, quatDelta);

