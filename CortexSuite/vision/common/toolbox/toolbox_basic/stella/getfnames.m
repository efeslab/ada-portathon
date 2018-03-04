% function [fn,dn] = getfnames(direc,opt) 
% Input:
%    direc = directory
%    opt = wildcat
% Output:
%    fn = a cell with all filenames under direc and with opt
%    dn = a cell with all directory names under direc and with opt
% For example, getfnames('19990910','*.jpg');
% Set IS_PC according to your platform in globalenvar.m

% Stella X. Yu, 2000.

function [fn,dn] = getfnames(direc,opt)

if (nargin<1 | isempty(direc)),
    direc = '.';
end

if nargin<2 | isempty(opt),
    opt = [];
end 

fn = {};
dn = {};

cur_dir = pwd;
cd(direc);
s = dir(opt);
if isempty(s),
   disp('getfnames: no data');
   return;
end
 
n = length(s);
i = 1; 
j = 1; 
for k=1:n,
   if s(k).isdir,
      dn{j,1} = s(k).name;
      j = j + 1;
   else
      fn{i,1} = s(k).name;
      i = i + 1;
   end
end
      cd(cur_dir)
%[fn{1:n,1}]=deal(s.name);
