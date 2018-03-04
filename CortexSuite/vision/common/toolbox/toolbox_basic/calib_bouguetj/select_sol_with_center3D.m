%%% Selection of the calibration solution with center estimation

solution = sol_with_center;

%%% Extraction of the final intrinsic and extrinsic paramaters:

extract_parameters3D;


fprintf(1,'\n\nCalibration results with principal point estimation:\n\n');
fprintf(1,'Focal Length:     fc = [ %3.5f   %3.5f]\n',fc);
fprintf(1,'Principal point:  cc = [ %3.5f   %3.5f]\n',cc);
fprintf(1,'Distortion:       kc = [ %3.5f   %3.5f   %3.5f   %3.5f]\n',kc);   


%%%%%%%%%%%%%%%%%%%% GRAPHICAL OUTPUT %%%%%%%%%%%%%%%%%%%%%%%%

graphout_calib3D;


