% function rec_num = ncutcheckin(fn,sdir,tdir)
% Input:
%    fn = parameter file name, default = 'command_ncut.tex'
%    sdir = source dir for fn as well as data files
%    tdir = target dir to check in, both default = IMAGE_DIR
% Output:
%    rec_num = the number of current parameter records
%    The imagefile_par.m is updated if fn contains a new 
%    parameter set.  Data files are tagged and copied over to 
%    a subdir under tdir.
% Example: ncutcheckin;
% Set IS_PC, IMAGE_DIR according to your platform in globalenvar.m

% Stella X. Yu, 2000.

function rec_num = ncutcheckin(fn,sdir,tdir)

globalenvar;

cur_dir = pwd;

if nargin<1 | isempty(fn),
   fn = 'command_ncut.tex';
end

if nargin<2 | isempty(sdir),
   sdir = IMAGE_DIR;
end

if nargin<3 | isempty(tdir),
   tdir = IMAGE_DIR;
end

rec = jshincutdefpar;

% first, generate a parameter record from fn
cd(sdir);
[names,values] = textread(fn,'%s %s','commentstyle','shell');
n = length(names);
s = rec;
for i=1:n,
   j = str2num(values{i});
   if isempty(j),
      s = setfield(s,names{i},values{i});
   else
      s = setfield(s,names{i},j);
   end
end
cd(cur_dir);

% special care to extract the image file name
imagename = getfield(s,names{1});
catchar = {'/','\'};
catchar = catchar{IS_PC + 1};
k = max([0,findstr(imagename,catchar)]);
imagename = imagename(k+1:end);
s = setfield(s,names{1},imagename);

% second, check if the target dir contains a profile for the image
cd(tdir);
if not(exist(imagename,'dir')),
   mkdir(imagename);
   cd(cur_dir);
   j = [catchar,imagename,'.',getfield(s,names{2})];
   copyfile([sdir,j],[tdir,catchar,imagename,j]);
   cd(tdir);
end
cd(imagename);
j = [imagename,'_par'];
if not(exist(j)),
   rec_num = 1;
   p = s;
else
   % load par file
   feval(j);    
   rec_num = length(p);
   i = 1;
   while (i<=rec_num),
      k = 0;
      for j=1:n,
         k = k + sum(getfield(s,names{j})-getfield(p(i),names{j}));
      end
      if k==0,
         if not(isempty(input(['Data already existed as record # ',num2str(i),...
                  '\nPress any non-return key to Overwrite'],'s'))),
            break;
         else
            rec_num = i; % have checked in already, no update
            cd(cur_dir);
            return;
         end
      else
         i = i + 1;
      end
   end            
   rec_num = i; % new parameter setting
   p(rec_num)=s;
end
tdir = [tdir,catchar,imagename];
cd(cur_dir);

% third, check in data files 
% leave .ppm and _edgecon, _phase files 
% if not(exist([tdir,catchar,imagename,'.ppm'])),
%   copyfile([sdir,catchar,imagename,'.ppm'],[tdir,catchar,imagename,'.ppm']);
% end

% IC files only
dn = getfnames(sdir,[imagename,'*_IC*.*']);
header = sprintf('%s%c%s_%d_',tdir,catchar,imagename,rec_num);
j = length(imagename)+2;
k = length(dn);
for i=1:k,
   copyfile([sdir,catchar,dn{i}],[header,dn{i}(j:end)]);
   delete([sdir,catchar,dn{i}]);
end
disp(sprintf('%d files checked in as record #%d',k,rec_num));


% finally, update parameter file
cd(tdir);
fid = fopen([imagename,'_par.m'],'w');
fprintf(fid,'%% Last checked in at %s\n\n',datestr(now));
for i=1:rec_num,
   for j=1:n,
      k = getfield(p(i),names{j});
      if ischar(k),
         fprintf(fid,'p(%d).%s=\''%s\'';\n',i,names{j},k);
      else
         fprintf(fid,'p(%d).%s=%s;\n',i,names{j},num2str(k));
      end
   end
   fprintf(fid,'\n');
end
fclose(fid);      
cd(cur_dir);