function script_run_profile(dataDir, resultDir, type, common, toolDir)

path(path, common);
file = fopen([dataDir, '/1.txt'], 'r');
full = fscanf(file,'%f');
elapsed = zeros(1,2);

rows = full(2);
cols = full(1);
fid = zeros(rows, cols);

k = 3;
for i=1:rows
    for j =1:cols
        fid(i,j) = full(k);
        k = k+1;
    end
end

fclose(file);

n=1000;

gyroTimeInterval=0.01;
acclTimeInterval=0.01;

STDDEV_GPSVel=0.5;

STDDEV_ODOVel=0.1;
STDDEV_ACCL=1;
M_STDDEV_GYRO=0.1;
M_STDDEV_POS=0.1;
M_STDDEV_VEL=0.02;

if(strcmp(type,'test'))
        n = 3;
        gyroTimeInterval = 0.1;
        acclTimeInterval = 0.1;
        M_STDDEV_VEL = 0.2;
    
elseif(strcmp(type, 'sim_fast'))
        n = 3;
elseif(strcmp(type, 'sim'))
        n = 10;
elseif(strcmp(type, 'sqcif'))
        n = 800;
elseif(strcmp(type, 'qcif'))
        n = 500;
elseif(strcmp(type, 'vga'))
        n = 2000;
elseif(strcmp(type, 'wuxga'))
        n = 3000;
end

fprintf(1,'Input size\t\t- (%dx%dx%d)\n', rows, cols,n);
pos=zeros(n,3);

vel=zeros(n,3) + randWrapper(n,3)*STDDEV_ODOVel;
pi = 3.1416;

eul1 = eul2quat([zeros(n,2), randWrapper(n,1)*2*pi]);
eul2 = eul2quat([pi, 0, 0]);
quat=quatMul(eul1, eul2);

i=0;
index = 0;
resultMat = zeros(3,rows);

while 1
    i=i+1;
    [tStamp, sType, sData, isEOF, index] = readSensorData(index, fid);

    start = photonStartTiming;

    if(sType==2)


        %Motion model
        gyro = sData(1, 1:3);
        randnWrapper_mat = randnWrapper(n,3);    % KVS: We do not have function implementation for randnWrapper()
        gyro=ones(n,1)*gyro+randnWrapper_mat*M_STDDEV_GYRO;

        abc = gyro.^2;
        abcd = sumCol(abc);
        norm_gyro = sqrt(abcd);
%        norm_gyro=sqrt(sum(gyro.^2,2));
        angleAlpha=norm_gyro*gyroTimeInterval;
        quatDelta=[cos(angleAlpha/2), gyro./(norm_gyro*ones(1,3)+0.00000001).*(sin(angleAlpha/2)*ones(1,3))];
        quat=quatMul(quat, quatDelta);

    end

    if(sType==4)
        %Observation
        STDDEV_GPSPos=[sData(1,7), 0, 0; 0, sData(1,8), 0; 0, 0, 15];
        Opos=sData(1,1:3);

        %Initialize
        
        randnWrapper_mat = randnWrapper(n,3);
        if sum(sum(pos))==0
            pos=ones(n,1) * Opos + randnWrapper_mat*STDDEV_GPSPos;
        else 
           rows = size(STDDEV_GPSPos, 1);
           cols = size(STDDEV_GPSPos, 2);

            temp_STDDEV_GPSPos = ones(rows,cols);
            for mnrows=1:rows                                 % KVS" Photon rejects this loop becasue of too many nestings ??
                for mncols=1:cols
                    temp_STDDEV_GPSPos(mnrows, mncols) = power(STDDEV_GPSPos(mnrows,mncols),-1);
                end
            end
           [temp, w]=mcl(pos, Opos , temp_STDDEV_GPSPos);
           [quat, vel, pos]=generateSample(w, quat, vel, pos, M_STDDEV_VEL, M_STDDEV_POS);
       end

       %compare direction
       Ovel=sData(1,4:6);

%        KVS: We do not have function for norm() yet! So replacing this operating with OvelNorm
  
%        OvelNorm=norm(Ovel);                               
       OvelNorm= 2.0;  %1.1169e+09;
       
       if (OvelNorm>0.5)
       
           % KVS: Similar here: No impln of norm(), so replacing
           % norm(Ovel) with OvelNorm value
           
           Ovel=Ovel/OvelNorm;
           %trick
           %quat=addEulNoise(quat, STDDEV_GPSVel);
           qConj = quatConj(quat);
            orgWorld=quatRot([1, 0, 0],qConj);
            eye3 = [1,0,0;0,1,0;0,0,1];
            [temp, w]=mcl(orgWorld, Ovel, eye3./STDDEV_GPSVel);
            [quat, vel, pos]=generateSample(w, quat, vel, pos, M_STDDEV_VEL, M_STDDEV_POS);
       end
 
   end
   
   if(sType==1)

       %Observation
       Ovel=sData(1,1);
       [temp, w]=mcl(sqrt(vel(:,1).^2+vel(:,2).^2+vel(:,3).^2), Ovel, 1/(STDDEV_ODOVel));

       [quat vel pos]=generateSample(w, quat, vel, pos, M_STDDEV_VEL, M_STDDEV_POS);
   end
   
   if(sType==3)
       %Observation
       accl=sData(1,1:3);
       
       gtemp = ones(n,1) * [0 0 -9.8];
       
       gravity=quatRot(gtemp, quat);
        eye3 = [1,0,0;0,1,0;0,0,1];
        [gravity, w]=mcl(gravity, accl, eye3./(STDDEV_ACCL));

        [quat, vel, pos]=generateSample(w, quat, vel, pos, M_STDDEV_VEL, M_STDDEV_POS);

        %Motion model
        accl=ones(n,1)*accl;
        accl=accl-gravity;
        pos=pos+quatRot(vel,quatConj(quat))*acclTimeInterval ...
            +1/2*quatRot(accl,quatConj(quat))*acclTimeInterval^2 ...
            +randnWrapper(n,3)*M_STDDEV_POS;
        vel=vel+accl*acclTimeInterval+randnWrapper(n,3)*M_STDDEV_VEL;

   end
   
    stop = photonEndTiming;
    
    temp = photonReportTiming(start, stop);
    elapsed(1) = elapsed(1) + temp(1);
    elapsed(2) = elapsed(2) + temp(2);

    % Self check

    quatOut = 0;
    posOut = 0;
    velOut = 0;

    for ij=1:(size(quat,1)*size(quat,2))
        quatOut = quatOut + quat(ij);
    end

    for ij=1:(size(vel,1)*size(vel,2))
        velOut = velOut + vel(ij);
    end

    for ij=1:(size(pos,1)*size(pos,2))
        posOut = posOut + pos(ij);
    end

    resultMat(:, i) = [quatOut, velOut, posOut];

    if (isEOF == 1)
        break;
    end
end

%% Timing
photonPrintTiming(elapsed);

%% Self checking %%
fWriteMatrix(resultMat,dataDir);

