	% Cleaned-up version of init_calib.m
   
   fprintf(1,'\nProcessing image %d...\n',kk);
   
	eval(['I = I_' num2str(kk) ';']);
   
   if exist(['wintx_' num2str(kk)]),
      
      eval(['wintxkk = wintx_' num2str(kk) ';']);
   
      if ~isempty(wintxkk) & ~isnan(wintxkk),

	 eval(['wintx = wintx_' num2str(kk) ';']);
	 eval(['winty = winty_' num2str(kk) ';']);
      
      end;
   end;
        
   
   fprintf(1,'Using (wintx,winty)=(%d,%d) - Window size = %dx%d\n',wintx,winty,2*wintx+1,2*winty+1);

   
	figure(2);
	image(I);
   colormap(map);
   
   title(['Click on the four extreme corners of the rectangular pattern... Image ' num2str(kk)]);
   
   disp('Click on the four extreme corners of the rectangular complete pattern...');
   
   [x,y] = ginput3(4);
   
   [Xc,good,bad,type] = cornerfinder([x';y'],I,winty,wintx); % the four corners
   
   x = Xc(1,:)';
   y = Xc(2,:)';
   
   [y,indy] = sort(y);
   x = x(indy);
   
   if (x(2) > x(1)),
      x4 = x(1);y4 = y(1); x3 = x(2); y3 = y(2);
   else
      x4 = x(2);y4 = y(2); x3 = x(1); y3 = y(1);
   end;
   if (x(3) > x(4)),
      x2 = x(3);y2 = y(3); x1 = x(4); y1 = y(4);
   else
      x2 = x(4);y2 = y(4); x1 = x(3); y1 = y(3);
   end;
   
   x = [x1;x2;x3;x4];
   y = [y1;y2;y3;y4];
   
   
   figure(2); hold on;
   plot([x;x(1)],[y;y(1)],'g-');
   plot(x,y,'og');
   hx=text((x(4)+x(3))/2,(y(4)+y(3))/2 - 20,'X');
   set(hx,'color','g','Fontsize',14);
   hy=text((x(4)+x(1))/2-20,(y(4)+y(1))/2,'Y');
   set(hy,'color','g','Fontsize',14);
   hold off;
   
   
   % Try to automatically count the number of squares in the grid
   
   n_sq_x1 = count_squares(I,x1,y1,x2,y2,wintx);
   n_sq_x2 = count_squares(I,x3,y3,x4,y4,wintx);
   n_sq_y1 = count_squares(I,x2,y2,x3,y3,wintx);
   n_sq_y2 = count_squares(I,x4,y4,x1,y1,wintx);
   
  
   
   % If could not count the number of squares, enter manually
   
   if (n_sq_x1~=n_sq_x2)|(n_sq_y1~=n_sq_y2),
      

	 disp('Could not count the number of squares in the grid. Enter manually.');
	 n_sq_x = input('Number of squares along the X direction ([]=10) = '); %6
	 if isempty(n_sq_x), n_sq_x = 10; end;
	 n_sq_y = input('Number of squares along the Y direction ([]=10) = '); %6
	 if isempty(n_sq_y), n_sq_y = 10; end; 
   
   else
               
      n_sq_x = n_sq_x1;
      n_sq_y = n_sq_y1;
      
   end;
   
   
   % Enter the size of each square
   
   dX = input(['Size dX of each square along the X direction ([]=' num2str(dX_default) 'mm) = ']);
  	dY = input(['Size dY of each square along the Y direction ([]=' num2str(dY_default) 'mm) = ']);
	if isempty(dX), dX = dX_default; else dX_default = dX; end;
	if isempty(dY), dY = dY_default; else dY_default = dY; end;
   
   % Compute the inside points through computation of the planar homography (collineation)
   
	a00 = [x(1);y(1);1];
	a10 = [x(2);y(2);1];
	a11 = [x(3);y(3);1];
	a01 = [x(4);y(4);1];


	% Compute the planar collineation: (return the normalization matrix as well)
   
   [Homo,Hnorm,inv_Hnorm] = compute_homography ([a00 a10 a11 a01],[0 1 1 0;0 0 1 1;1 1 1 1]);


	% Build the grid using the planar collineation:

	x_l = ((0:n_sq_x)'*ones(1,n_sq_y+1))/n_sq_x;
   y_l = (ones(n_sq_x+1,1)*(0:n_sq_y))/n_sq_y;
   pts = [x_l(:) y_l(:) ones((n_sq_x+1)*(n_sq_y+1),1)]';
   
   XX = Homo*pts;
	XX = XX(1:2,:) ./ (ones(2,1)*XX(3,:));

   
   % Complete size of the rectangle
   
   W = n_sq_x*dX;
   L = n_sq_y*dY;
   
   
   
   
   %%%%%%%%%%%%%%%%%%%%%%%% ADDITIONAL STUFF IN THE CASE OF HIGHLY DISTORTED IMAGES %%%%%%%%%%%%%
   figure(2);
   hold on;
   plot(XX(1,:),XX(2,:),'r+');
   title('The red crosses should be close to the image corners');
   hold off;
   
   disp('If the guessed grid corners (red crosses on the image) are not close to the actual corners,');
   disp('it is necessary to enter an initial guess for the radial distortion factor kc (useful for subpixel detection)');
   quest_distort = input('Need of an initial guess for distortion? ([]=no, other=yes) ');
  
   quest_distort = ~isempty(quest_distort);
   
   if quest_distort,
      % Estimation of focal length:
      c_g = [size(I,2);size(I,1)]/2 + .5;
		f_g = Distor2Calib(0,[[x(1) x(2) x(4) x(3)] - c_g(1);[y(1) y(2) y(4) y(3)] - c_g(2)],1,1,4,W,L,[-W/2 W/2 W/2 -W/2;L/2 L/2 -L/2 -L/2; 0 0 0 0],100,1,1);
      f_g = mean(f_g);
      script_fit_distortion;
   end;
   %%%%%%%%%%%%%%%%%%%%% END ADDITIONAL STUFF IN THE CASE OF HIGHLY DISTORTED IMAGES %%%%%%%%%%%%%
   
   
   
   
   
   Np = (n_sq_x+1)*(n_sq_y+1);

   disp('Corner extraction...');
   
   grid_pts = cornerfinder(XX,I,winty,wintx); %%% Finds the exact corners at every points!
   

   
   %save all_corners x y grid_pts
   
   grid_pts = grid_pts - 1; % subtract 1 to bring the origin to (0,0) instead of (1,1) in matlab (not necessary in C)
   
   
   
   ind_corners = [1 n_sq_x+1 (n_sq_x+1)*n_sq_y+1 (n_sq_x+1)*(n_sq_y+1)]; % index of the 4 corners
   ind_orig = (n_sq_x+1)*n_sq_y + 1;
   xorig = grid_pts(1,ind_orig);
   yorig = grid_pts(2,ind_orig);
   dxpos = mean([grid_pts(:,ind_orig) grid_pts(:,ind_orig+1)]');
   dypos = mean([grid_pts(:,ind_orig) grid_pts(:,ind_orig-n_sq_x-1)]');
   
   
   x_box_kk = [grid_pts(1,:)-(wintx+.5);grid_pts(1,:)+(wintx+.5);grid_pts(1,:)+(wintx+.5);grid_pts(1,:)-(wintx+.5);grid_pts(1,:)-(wintx+.5)];
   y_box_kk = [grid_pts(2,:)-(winty+.5);grid_pts(2,:)-(winty+.5);grid_pts(2,:)+(winty+.5);grid_pts(2,:)+(winty+.5);grid_pts(2,:)-(winty+.5)];

   
   figure(3);
   image(I); colormap(map); hold on;
   plot(grid_pts(1,:)+1,grid_pts(2,:)+1,'r+');
   plot(x_box_kk+1,y_box_kk+1,'-b');
   plot(grid_pts(1,ind_corners)+1,grid_pts(2,ind_corners)+1,'mo');
   plot(xorig+1,yorig+1,'*m');
   h = text(xorig-15,yorig-15,'O');
   set(h,'Color','m','FontSize',14);
   h2 = text(dxpos(1)-10,dxpos(2)-10,'dX');
   set(h2,'Color','g','FontSize',14);
   h3 = text(dypos(1)-25,dypos(2)-3,'dY');
   set(h3,'Color','g','FontSize',14);
   xlabel('Xc (in camera frame)');
   ylabel('Yc (in camera frame)');
   title('Extracted corners');
   zoom on;
   drawnow;
   hold off;
   
   
   Xi = reshape(([0:n_sq_x]*dX)'*ones(1,n_sq_y+1),Np,1)';
   Yi = reshape(ones(n_sq_x+1,1)*[n_sq_y:-1:0]*dY,Np,1)';
   Zi = zeros(1,Np);
   
   Xgrid = [Xi;Yi;Zi];
   
   
	% All the point coordinates (on the image, and in 3D) - for global optimization:

   x = grid_pts;
   X = Xgrid;


	% Saves all the data into variables:

   eval(['dX_' num2str(kk) ' = dX;']);
   eval(['dY_' num2str(kk) ' = dY;']);  
   
   eval(['wintx_' num2str(kk) ' = wintx;']);
   eval(['winty_' num2str(kk) ' = winty;']);

   eval(['x_' num2str(kk) ' = x;']);
   eval(['X_' num2str(kk) ' = X;']);
   
   eval(['n_sq_x_' num2str(kk) ' = n_sq_x;']);
   eval(['n_sq_y_' num2str(kk) ' = n_sq_y;']);
   