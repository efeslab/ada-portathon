

%%%%%%%%%%%%%%%%%%%% GRAPHICAL OUTPUT %%%%%%%%%%%%%%%%%%%%%%%%


% Color code for each image:

colors = 'brgkcm';


%%% Show the extrinsic parameters

IP = 8*dX*([0 nx-1 nx-1 0 0 ; 0 0 ny-1 ny-1 0;1 1 1 1 1] - [cc;0]*ones(1,5)) ./ ([fc;1]*ones(1,5));


figure(4);
[a,b] = view;

figure(4);
plot3(5*[0 dX 0 0 0 0 ],5*[0 0 0 0 0 dX],-5*[0 0 0 dX 0 0 ],'b-','linewidth',2');
hold on;
plot3(IP(1,:),IP(3,:),-IP(2,:),'r-','linewidth',2);
text(6*dX,0,0,'X_c');
text(-dX,5*dX,0,'Z_c');
text(0,0,-6*dX,'Y_c');
text(-dX,-dX,dX,'O_c');


for kk = 1:n_ima,
   
   eval(['XX_kk = X_' num2str(kk) ';']);
   eval(['omc_kk = omc_' num2str(kk) ';']);
   eval(['Tc_kk = Tc_' num2str(kk) ';']);
   
   eval(['nl_sq_x = nl_sq_x_' num2str(kk) ';']);
   eval(['nl_sq_y = nl_sq_y_' num2str(kk) ';']);
   
   eval(['nr_sq_x = nr_sq_x_' num2str(kk) ';']);
   eval(['nr_sq_y = nr_sq_y_' num2str(kk) ';']);

   R_kk = rodrigues(omc_kk);
   
   YY_kk = R_kk * XX_kk + Tc_kk * ones(1,length(XX_kk));
   
   YYl_kk = YY_kk(:,1:(nl_sq_x+1)*(nl_sq_y+1));
   YYr_kk = YY_kk(:,(nl_sq_x+1)*(nl_sq_y+1)+1:end);

   
   eval(['YYl_' num2str(kk) ' = YYl_kk;']);
   eval(['YYr_' num2str(kk) ' = YYr_kk;']);
   
   uu = [-dX;-dY;0]/2;
   uu = R_kk * uu + Tc_kk; 
   
   YYlx = zeros(nl_sq_x+1,nl_sq_y+1);
   YYly = zeros(nl_sq_x+1,nl_sq_y+1);
   YYlz = zeros(nl_sq_x+1,nl_sq_y+1);
   
   YYrx = zeros(nr_sq_x+1,nr_sq_y+1);
   YYry = zeros(nr_sq_x+1,nr_sq_y+1);
   YYrz = zeros(nr_sq_x+1,nr_sq_y+1);
   
   YYlx(:) = YYl_kk(1,:);
   YYly(:) = YYl_kk(2,:);
   YYlz(:) = YYl_kk(3,:);
   
   YYrx(:) = YYr_kk(1,:);
   YYry(:) = YYr_kk(2,:);
   YYrz(:) = YYr_kk(3,:);
   
   
   %keyboard;
   
   figure(4);
   hhh= mesh(YYlx,YYlz,-YYly);
   set(hhh,'edgecolor',colors(rem(kk-1,6)+1),'linewidth',1); %,'facecolor','none');
   %plot3(YY_kk(1,:),YY_kk(3,:),-YY_kk(2,:),['o' colors(rem(kk-1,6)+1)]);
   hhh= mesh(YYrx,YYrz,-YYry);
   set(hhh,'edgecolor',colors(rem(kk-1,6)+1),'linewidth',1);
   text(uu(1),uu(3),-uu(2),num2str(kk),'fontsize',14,'color',colors(rem(kk-1,6)+1));
   
end;

figure(4);rotate3d on;
axis('equal');
title('Extrinsic parameters');
%view(60,30);
view(a,b);
hold off;



% Reproject the patterns on the images, and compute the pixel errors:

% Reload the images if necessary

if ~exist('I_1'),
   ima_read_calib;
   if no_image_file,
      return;
   end;
end;


ex = []; % Global error vector
x = []; % Detected corners on the image plane
y = []; % Reprojected points

for kk = 1:n_ima,
   
   eval(['omckk = omc_' num2str(kk) ';']);
   eval(['Tckk = Tc_' num2str(kk) ';']);
   
   Rkk = rodrigues(omckk);
   
   eval(['y_' num2str(kk) '  = project2_oulu(X_' num2str(kk) ',Rkk,Tckk,fc,cc,kc);']);

   eval(['ex_' num2str(kk) ' = x_' num2str(kk) ' -y_' num2str(kk) ';']);
   
   eval(['x_kk = x_' num2str(kk) ';']);
   
   figure(4+kk);
   eval(['I = I_' num2str(kk) ';']);
   image(I); hold on;
   colormap(gray(256));
   title(['Image ' num2str(kk) ' - Image points (+) and reprojected grid points (o)']);
   eval(['plot(x_' num2str(kk) '(1,:)+1,x_' num2str(kk) '(2,:)+1,''r+'');']);
   eval(['plot(y_' num2str(kk) '(1,:)+1,y_' num2str(kk) '(2,:)+1,''' colors(rem(kk-1,6)+1) 'o'');']);
   zoom on;
   hold off;
   
   
   eval(['ex = [ex ex_' num2str(kk) '];']);
   eval(['x = [x x_' num2str(kk) '];']);
   eval(['y = [y y_' num2str(kk) '];']);
   
end;


figure(5+n_ima);
for kk = 1:n_ima,
   eval(['plot(ex_' num2str(kk) '(1,:),ex_' num2str(kk) '(2,:),''' colors(rem(kk-1,6)+1) '+'');']);
   hold on;
end;
hold off;
axis('equal');
title('Reprojection error (in pixel)');
xlabel('x');
ylabel('y');

err_std = std(ex')';

fprintf(1,'Pixel error:      err = [ %3.5f   %3.5f]\n\n',err_std); 
