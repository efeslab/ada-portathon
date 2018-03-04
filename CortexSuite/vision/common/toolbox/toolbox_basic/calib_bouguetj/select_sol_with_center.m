%%% Selection of the calibration solution with center estimation

if ~exist('sol_with_center'),
   fprintf(1,'Need to calibrate before selecting solution with center. Maybe need to load Calib_Results.mat file.\n');
   return;
end;

solution = sol_with_center;

%%% Extraction of the final intrinsic and extrinsic paramaters:

extract_parameters;
comp_error_calib;

fprintf(1,'\n\nCalibration results with principal point estimation:\n\n');
fprintf(1,'Focal Length:     fc = [ %3.5f   %3.5f]\n',fc);
fprintf(1,'Principal point:  cc = [ %3.5f   %3.5f]\n',cc);
fprintf(1,'Distortion:       kc = [ %3.5f   %3.5f   %3.5f   %3.5f]\n',kc);   
fprintf(1,'Pixel error:      err = [ %3.5f   %3.5f]\n\n',err_std); 
