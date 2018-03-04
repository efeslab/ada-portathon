function ex = multi_error_oulu(param,n_ima,cc);

global X_1 x_1 X_2 x_2 X_3 x_3 X_4 x_4 X_5 x_5 X_6 x_6 X_7 x_7 X_8 x_8 X_9 x_9 X_10 x_10 X_11 x_11 X_12 x_12 X_13 x_13 X_14 x_14 X_15 x_15 X_16 x_16 X_17 x_17 X_18 x_18 X_19 x_19 X_20 x_20 X_21 x_21 X_22 x_22 X_23 x_23 X_24 x_24 X_25 x_25 X_26 x_26 X_27 x_27 X_28 x_28 X_29 x_29 X_30 x_30

fc = param(1:2);
kc = param(3:6);
%ppc = param(5:6);

if length(param) > 6*n_ima + 3 + 3,
   
   cc = param(6*n_ima + 4 + 3:6*n_ima + 5 + 3);
   
   if length(param) > 6*n_ima + 5 + 3,
      
      c_d = param(6*n_ima + 6 + 3 :6*n_ima + 7 + 3);
      
   else
      
      c_d = [0;0];
      
   end;
   
else
   
   c_d = [0;0];

end;



ex = [];

%keyboard;

for kk = 1:n_ima,
   
   omckk = param(4+6*(kk-1) + 3:6*kk + 3);
   
   Tckk = param(6*kk+1 + 3:6*kk+3 + 3);

   Rkk = rodrigues(omckk);

   eval(['ykk = project2_oulu(X_' num2str(kk) ',Rkk,Tckk,fc,cc,kc);']);
   
   eval(['exkk = x_' num2str(kk) ' -ykk;']);

   ex = [ex;exkk(:)];
   
end;
