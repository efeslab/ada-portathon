% function [v,s,d] = firstncut(base_name,rec_num)
% Input:
%    base_name = image name
%    rec_num = parameter record number 
% Output:
%    v = eigenvectors
%    s = eigenvalues
%    d = normalization matrix d = 1/sqrt(rowsum(abs(a)))
% Convert Jianbo Shi's Ncut Ccode results from images to matlab matrices.

% Stella X. Yu, 2000.

function [v,s,d] = firstncut(base_name,rec_num);

if nargin<2 | isempty(rec_num),
   rec_num = 1;
end

cur_dir = pwd;
globalenvar;
cd(IMAGE_DIR);
cd(base_name);
   feval([base_name,'_par']);
   j = length(p);
   if rec_num>j,
      disp(sprintf('parameter record number %d out of range %d, check %s!',rec_num,j,[base_name,'_par.m']));
      Qlabel = [];
      v = [];
      s = [];
      ev_info = [];
      return;
   end
   nv = p(rec_num).num_eigvecs;
   no_rep = (p(rec_num).offset<1e-6);
   
   % read the image
   cm=sprintf('I = readppm(''%s.ppm'');',base_name);
   eval(cm);

   % read eigenvectors   
   base_name_hist = sprintf('%s_%d_IC',base_name,rec_num);
   if no_rep,
      [v,ev_info] = read_ev_pgm(base_name_hist,1,1,nv);
   else
      [v,ev_info] = read_ev_pgm2(base_name_hist,1,1,nv);
   end
   s = ev_info(4,:)';
   
   % read the normalization matrix
   d = readpfmc(sprintf('%s_%d_D_IC.pfm',base_name,rec_num));   
cd(cur_dir);

% D^(1/2)
dd = (1./(d(:)+eps));

% recover real eigenvectors
for j = 1:nv-no_rep,
   vmin = ev_info(1,j);
   vmax = ev_info(2,j);
   y = v(:,:,j).*((vmax - vmin)/256) + vmin;
   %validity check: x = D^(1/2)y should be normalized
   x = norm(y(:).*dd);
   v(:,:,j) = y./x;
end

dispimg(cat(3,mean(I,3),v),[],[{'image'};cellstr(num2str(s,3))]);

