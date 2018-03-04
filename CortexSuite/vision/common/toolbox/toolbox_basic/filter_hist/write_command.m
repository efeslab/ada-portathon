function write_command(fname,fn_base,para)

fid = fopen(fname,'w');

fprintf(fid,'%s ',fn_base);
fprintf(fid,'%d ',para);
fprintf(fid,'\nrun\n');
fclose(fid);
