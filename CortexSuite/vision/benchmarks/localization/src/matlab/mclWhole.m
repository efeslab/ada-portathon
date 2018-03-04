function retW=mclWhole(quat, Ovel, STDDEV_GPSVel, accl, STDDEV_ACCL)
n=size(quat,1);
OvelNorm=norm(Ovel);
if (OvelNorm>0.5)
    Ovel=Ovel/norm(Ovel);
    %trick
    %quat=addEulNoise(quat, STDDEV_GPSVel); 
    orgWorld=quatRot([1 0 0],quatConj(quat));
    p1=get3DGaussianProb(orgWorld, Ovel, eye(3)./STDDEV_GPSVel);
else
    p1=zeros(n,1);
end

gravity=quatRot(ones(n,1)*[0 0 -9.8], quat);
p2=get3DGaussianProb(gravity, accl, eye(3)./(STDDEV_ACCL));
retW=p1+p2;
retW=retW/sum(retW);
            