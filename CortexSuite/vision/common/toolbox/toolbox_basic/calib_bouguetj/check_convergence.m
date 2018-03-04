%%% Replay the set of solution vectors:

N_iter = size(param_list,2);

for nn = 1:N_iter,
   
   solution = param_list(:,nn);
   
   extract_parameters;
   comp_error_calib;
   
   ext_calib;
   
   drawnow;
   
   
end;
