fn = 'walk1';

repulsion_test = 1;

if 1,
   f = getimage2(fn);
   par = jshincutdefpar;
   par.fname_base = fn;
   par.spatial_neighborhood_x = 10;
   par.sigma_x = 3 * par.spatial_neighborhood_x;
   par.sig_IC = 0.03;
   par.num_eigvecs = 10;
   par.offset = 0.00;
   par.sig_filter = 1.0;
   par.elong_filter = 3.0;
   [par,rec_num] = jshincut(par);
   [g,lgd,v,s,dd] = showncut(fn,rec_num);

if repulsion_test,
   par.offset = 0.1;
   [par,rec_num] = jshincut(par);
   figure;
   [g,lgd,v,s,dd] = showncut(fn,rec_num);
end
end

if 0,
   x = v(:,:,1);
   y = v(:,:,2);
   figure;
   subplot(2,1,1); plot(x(:),y(:),'ro');
   r = sqrt(x.^2+y.^2);
   x = x./r;
   y = y./r;
   subplot(2,1,2); im([x,y]*[x,y]');
 %  mask = (x>0) & y>0;
 %  showmask(f,mask);
end
