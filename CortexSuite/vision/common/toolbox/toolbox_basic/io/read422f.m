function I = read422(fname,nc);
%
%   I = read422(fname,width);
%
%      read in a .422 file, need to pass image width, default = 640
%

% assume image width = 640
if nargin<2,
  nc = 640;
end

%% find the image size
fid = fopen(fname);
fseek(fid,0,1);
fsize = ftell(fid);

nr = fsize/nc/2;

fseek(fid,0,-1);

%% read in Ybr data
data = fread(fid,fsize,'uchar');

%%% extract Y, Cb, Cr
Y1 = data(1:2:end);  Y1 = reshape(Y1,nc,nr)';
Cb1 = data(2:4:end); Cb1 = reshape(Cb1,nc/2,nr)';
Cr1 = data(4:4:end); Cr1 = reshape(Cr1,nc/2,nr)';

Cb = zeros(size(Y1)); 
Cr = zeros(size(Y1));

Cb(:,1:2:end) = Cb1;  Cb(:,2:2:end) = Cb1;
%Cb(:,2:2:end) = 0.5*(Cb1+[Cb1(:,2:end),Cb1(:,end)]);

Cr(:,1:2:end) = Cr1; Cr(:,2:2:end) = Cr1;
%Cr(:,2:2:end) = 0.5*(Cr1+[Cr1(:,2:end),Cr1(:,end)]);

%%% convert to r,g,b
r = 1.164*(Y1-16.0) + 1.596*(Cr-128.0);
g = 1.164*(Y1-16.0) - 0.813*(Cr-128.0) - 0.391*(Cb-128.0);
b = 1.164*(Y1-16.0) + 2.018*(Cb-128.0);

r = flipud(max(0,min(r,255)));
g = flipud(max(0,min(g,255)));
b = flipud(max(0,min(b,255)));

I = cat(3,r,g,b);

I = permute(I/255,[2,1,3]);
