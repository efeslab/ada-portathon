function I = compact(img,ws)


%ws = 2*hws+1;

[sy,sx] = size(img);

rem_x = rem(sx,ws);
rem_y = rem(sy,ws);

fix_x = ceil(sx/ws);
fix_y = ceil(sy/ws);

fprintf('nr = %d, nc = %d\n',fix_y,fix_x);

%startx= 1 + floor(rem_x*0.5)+hws;
%starty= 1 + floor(rem_y*0.5)+hws;

I = zeros(fix_y,fix_x);

yid = 0;
for j=1:ws:sy,
   xid = 0;
   yid = yid +1;
   fprintf('.');
   for k=1:ws:sx,
       xid = xid+1;
       %I(yid,xid) = median(median(img(j-hws:j+hws,k-hws:k+hws)));
       %I(yid,xid) = sum(sum(img(j-hws:j+hws,k-hws:k+hws)));
       v = img(j:min(sy,j+ws-1),k:min(sx,k+ws-1));
       %I(yid,xid) = median(reshape(v,prod(size(v)),1));
       I(yid,xid) = median(median(v));
   end
end
fprintf('\n');
 