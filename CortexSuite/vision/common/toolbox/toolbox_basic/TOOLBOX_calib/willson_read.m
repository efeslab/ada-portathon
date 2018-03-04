% Read in Reg Willson's data file, and convert it into my data format:

%dir;

%calib_file = input('Reg Willson calibration file name: ','s');

if exist(calib_file),

	
	load(calib_file);
	
	inddot = find(calib_file == '.');
	
   if isempty(inddot),
      varname = calib_file;
   else
      varname = calib_file(1:inddot(1)-1);   	
	end;
	
	eval(['calib_params = ' varname ';'])
	
	Ncx = calib_params(1);
   Nfx = calib_params(2);
   dx = calib_params(3);
   dy = calib_params(4);
   dpx = calib_params(5);
   dpy = calib_params(6);
   Cx = calib_params(7);
   Cy = calib_params(8);
   sx = calib_params(9);
   f = calib_params(10);
   kappa1 = calib_params(11);
   Tx = calib_params(12);
   Ty = calib_params(13);
   Tz = calib_params(14);
   Rx = calib_params(15);
   Ry = calib_params(16);
   Rz = calib_params(17);
   p1 = calib_params(18);
   p2 = calib_params(19);
   
   % Conversion:
   [fc,cc,kc,Rc_1,Tc_1,omc_1,nx,ny] = willson_convert(Ncx,Nfx,dx,dy,dpx,dpy,Cx,Cy,sx,f,kappa1,Tx,Ty,Tz,Rx,Ry,Rz,p1,p2);
   
   KK = [fc(1) 0 cc(1);0 fc(2) cc(2) ; 0 0 1];
   
   n_ima = 1;
   
   X_1 = [NaN;NaN;NaN];
   x_1 = [NaN;NaN];
   
   map = gray(256);
   
else
   
   disp(['WARNING: Calibration file ' calib_file ' not found']);
   
end;

