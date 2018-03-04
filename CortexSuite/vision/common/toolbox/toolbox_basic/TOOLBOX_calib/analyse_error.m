% Color code for each image:

if ~exist('n_ima')|~exist('fc'),
   fprintf(1,'No calibration data available.\n');
   return;
end;

check_active_images;

if ~exist(['ex_' num2str(ind_active(1)) ]),
   fprintf(1,'Need to calibrate before analysing reprojection error. Maybe need to load Calib_Results.mat file.\n');
   return;
end;


%if ~exist('no_grid'),
   no_grid = 0;
%end;

colors = 'brgkcm';

   
figure(5);
   
for kk = 1:n_ima,
   if exist(['y_' num2str(kk)]),
   if active_images(kk) & eval(['~isnan(y_' num2str(kk) '(1,1))']),
      
      if ~no_grid,
	 eval(['XX_kk = X_' num2str(kk) ';']);
	 N_kk = size(XX_kk,2);
	 
	 if ~exist(['n_sq_x_' num2str(kk)]),
	    no_grid = 1;
	 end;
	 
	 if ~no_grid,
	    eval(['n_sq_x = n_sq_x_' num2str(kk) ';']);
	    eval(['n_sq_y = n_sq_y_' num2str(kk) ';']);
	    if (N_kk ~= ((n_sq_x+1)*(n_sq_y+1))),
	       no_grid = 1;
	    end;
	 end;
      end;
      
      eval(['plot(ex_' num2str(kk) '(1,:),ex_' num2str(kk) '(2,:),''' colors(rem(kk-1,6)+1) '+'');']);
      
      hold on;
   end;
   end;
end;

hold off;
axis('equal');
if 1, %~no_grid,
   title('Reprojection error (in pixel) - To exit: right button');
else
   title('Reprojection error (in pixel)');   
end;
xlabel('x');
ylabel('y');

set(5,'Name','error','NumberTitle','off');



err_std = std(ex')';

fprintf(1,'Pixel error:          err = [ %3.5f   %3.5f] (all active images)\n\n',err_std); 


b = 1;

while b==1,
   
[xp,yp,b] = ginput3(1);

if b==1,
ddd = (ex(1,:)-xp).^2 + (ex(2,:)-yp).^2;

[mind,indmin] = min(ddd);


done = 0;
kk_ima = 1;
while (~done)&(kk_ima<=n_ima),
   %fprintf(1,'%d...',kk_ima);
   eval(['ex_kk = ex_' num2str(kk_ima) ';']);
   sol_kk = find((ex_kk(1,:) == ex(1,indmin))&(ex_kk(2,:) == ex(2,indmin)));
   if isempty(sol_kk),
   	kk_ima = kk_ima + 1;
   else
      done = 1;
   end;
end;

if ~no_grid,

eval(['n_sq_x = n_sq_x_' num2str(kk_ima) ';']);
eval(['n_sq_y = n_sq_y_' num2str(kk_ima) ';']);

Nx = n_sq_x+1;
Ny = n_sq_y+1;

y1 = floor((sol_kk-1)./Nx);
x1 = sol_kk - 1 - Nx*y1; %rem(sol_kk-1,Nx);

y1 = (n_sq_y+1) - y1;
x1 = x1 + 1;

fprintf(1,'\nSelected image: %d\nSelected point: (col,row)=(%d,%d)\nNcol=%d, Nrow=%d\n',[kk_ima x1 y1 Nx Ny]);
fprintf(1,'Pixel error = (%3.5f,%3.5f)\n',[ex(1,indmin) ex(2,indmin)]);

else
   
   eval(['x_kk = x_' num2str(kk_ima) ';']);
   
   xpt = x_kk(:,sol_kk);
   
fprintf(1,'\nSelected image: %d\nImage coordinates (in pixel): (%3.2f,%3.2f)\n',[kk_ima xpt']);
fprintf(1,'Pixel error = (%3.5f,%3.5f)\n',[ex(1,indmin) ex(2,indmin)]);


end;


if exist(['wintx_' num2str(kk_ima)]),

   eval(['wintx = wintx_' num2str(kk_ima) ';']);
   eval(['winty = winty_' num2str(kk_ima) ';']);
   
   fprintf(1,'Window size: wintx = %d, winty = %d\n',[wintx winty]);
end;


end;

end;

disp('done');

