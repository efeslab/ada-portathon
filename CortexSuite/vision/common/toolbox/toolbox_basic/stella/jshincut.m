% function [par, rec_num] = jshincut(par,image_dir)
% Input:
%   par = a structure with parameters for command_ncut.tex
%   image_dir = the directory where the imagefile is stored
% Output:
%   par = parameters used
%   rec_num = record number in the NCut database
% Jianbo Shi's ncut_IC is applied to the image
%   (If there is no .ppm format for the named image,
%   conversion from related files would be attempted.)
%   Results are organized according to the parameters.
% Example: jshincut('240018s');
% See also: jshincutdefpar; ncutcheckin
% Set IS_PC according to your platform in globalenvar.m

% Stella X. Yu, 2000.

function [par,rec_num] = jshincut(par,image_dir)

rec = jshincutdefpar;

fields = fieldnames(rec);
nf = length(fields);

if ischar(par),
   imagename = par; 
   par = rec;
   par.fname_base = imagename;
end

globalenvar;
   
if nargin<2 | isempty(image_dir),
   image_dir = IMAGE_DIR;
end

imagename = getfield(par,fields{1});
for i=2:nf,
   t = getfield(par,fields{i});
   if isempty(t),
      par = setfield(par,fields{i},getfield(rec,fields{i}));
   end
end

% dir and filename 
catchar = {'/','\'};
catchar = catchar{IS_PC+1};

% first check if there is a ppm file for this image
if not(exist([image_dir,catchar,imagename,'.ppm'])),
   j = getfnames(image_dir,[imagename,'.*']);
   if isempty(j),
      disp('Image not found.');
      return;
   end
   k = 0;
   for i=1:length(j),
      k = k + not(isempty(im2ppm(j{i},image_dir)));
      if k==1,
         disp(sprintf('%s -> %s.ppm succeeded.',j{i},imagename));
         break;
      end
   end
   if k==0,
      disp('Sorry.  Attempt to convert your named image into ppm format failed.');
      return;
   end
end

cd(C_DIR);

% generate command_ncut.tex file
fn = 'command_ncut.tex';
fid = fopen(fn,'w');
fprintf(fid,'%21s\t%s%c%s\n',fields{1},image_dir,catchar,imagename);
for i=2:nf,
   t = getfield(par,fields{i});
   if isnumeric(t),
      t = num2str(t);
   end
   fprintf(fid,['%21s\t%s\n'],fields{i},t);
end
fclose(fid);
%disp('You can check and modify command_ncut.tex before I run ncut_IC on it.  Good?');pause(1);

% run ncut_IC
unix(['.',catchar,'ncut_IC']);
cd(HOME_DIR);

% check in
copyfile([C_DIR,catchar,fn],[image_dir,catchar,fn]);
rec_num = ncutcheckin(fn,image_dir,image_dir);
%delete([image_dir,catchar,imagename,'.ppm']);
%delete([image_dir,catchar,fn]);
