%% Converts data file from oulu to mine:

load cademo,
n_ima = 0;

no_error = 1;

ii = 1;

while no_error,
   
   dataname = ['data' num2str(ii)];
   
   if exist(dataname),
      
      n_ima = n_ima +1;
      
      eval(['x_' num2str(ii) '= ' dataname '(:,4:5)'';'])
      eval(['X_' num2str(ii) '= ' dataname '(:,1:3)'';'])
      
   else
      no_error = 0;
   end;
   
   ii = ii + 1;
   
end;

nx = 500;
ny = 500;

no_image = 1;
no_grid = 1;

save data  n_ima x_1 X_1 x_2 X_2 x_3 X_3 nx ny no_image no_grid
