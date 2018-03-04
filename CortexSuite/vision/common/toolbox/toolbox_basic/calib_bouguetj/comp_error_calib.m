%%%%%%%%%%%%%%%%%%%% RECOMPUTES THE REPROJECTION ERROR %%%%%%%%%%%%%%%%%%%%%%%%

check_active_images;

% Reproject the patterns on the images, and compute the pixel errors:

ex = []; % Global error vector
x = []; % Detected corners on the image plane
y = []; % Reprojected points

for kk = 1:n_ima,
   
   eval(['omckk = omc_' num2str(kk) ';']);
   eval(['Tckk = Tc_' num2str(kk) ';']);   
   
   if active_images(kk) & (~isnan(omckk(1,1))),
      
      Rkk = rodrigues(omckk);
      
      eval(['y_' num2str(kk) '  = project2_oulu(X_' num2str(kk) ',Rkk,Tckk,fc,cc,kc);']);
      
      eval(['ex_' num2str(kk) ' = x_' num2str(kk) ' -y_' num2str(kk) ';']);
      
      eval(['x_kk = x_' num2str(kk) ';']);
      
      eval(['ex = [ex ex_' num2str(kk) '];']);
      eval(['x = [x x_' num2str(kk) '];']);
      eval(['y = [y y_' num2str(kk) '];']);
      
   else
      
   	eval(['y_' num2str(kk) '  = NaN*ones(2,1);']);

	   eval(['ex_' num2str(kk) ' = NaN*ones(2,1);']);
      
   end;
   
end;

err_std = std(ex')';
