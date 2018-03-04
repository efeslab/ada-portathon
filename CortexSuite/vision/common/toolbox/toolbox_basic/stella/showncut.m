% function [g,lgd,v,s,dd] = showncut(fn,rec_num)
% Input:
%    fn = file / image name
%    rec_num = Ncut record number
% Output:
%    g = a cell contains 1D, 2D and 3D embeddings
%    lgd = legend for g
%    v = eigenvectors
%    s = eigenvalues
%    dd = normalization matrix  = 1/sqrt(rowsum(abs(a))) 
%    an image is displayed

function [g,lgd,v,s,dd] = showncut(fn,rec_num)

globalenvar; cd(IMAGE_DIR);cd(fn); feval([fn,'_par']);cd(HOME_DIR);
par = p(rec_num);
no_rep = (par.offset<1e-6);
                   
[v,s,dd] = firstncut(fn,rec_num);
[m,n,nc] = size(v);

% generate images for display
nr = 5;
num_plots = nc * nr;
g = cell(num_plots,1);
lgd = g;
names = {'r','\theta','\phi'};
x = cell(3,1);
for j=1:nc,
    g{j} = v(:,:,j);
    lgd{j} = sprintf('%s_{%d} = %1.2f','\lambda', j+no_rep, s(j));

    if j<nc,
       [x{2},x{1}] = cart2pol(v(:,:,j),v(:,:,j+1));
       k = j;
       for t=1:2,
           k = k + nc;
           g{k} = x{t};
           lgd{k} = sprintf('%s_{%d,%d}',names{t},j+[0:1]+no_rep);
       end
       
       if j<nc-1,
          [x{2},x{3},x{1}] = cart2sph(v(:,:,j),v(:,:,j+1),v(:,:,j+2));
          for t=[1,3], % theta must be the same as 2D embedding, so ignore it
              k = k + nc;
              g{k} = x{t};
              lgd{k} = sprintf('%s_{%d,%d,%d}',names{t},j+[0:2]+no_rep);
          end
       end
    end
end

% fill in slots by image f and affinity pattern
j = nc + nc; g{j} = getimage2(fn); lgd{j} = sprintf('%d x %d image',m,n);
j = nr * nc; g{j} = readpcm([fn,'_phase.pfm']); lgd{j} = 'phase';
j = j - 1;  g{j} = exp(-(readpfmc([fn,'_edgecon.pfm'])/(255*par.sig_IC)).^2); lgd{j} = 'IC';

i = round(m*[1;3]./4);
%i = i([1,1,2,2]);
j = round(n*[1;3]./4);
%j = j([1,2,1,2]);
k = m * (j-1) + i;

a = afromncut(v,s,dd,1,no_rep,k);

y = [4*nc-1, 4*nc, 5*nc-1, 5*nc, 6*nc-1, 6*nc]; 
for t=1:length(k),
    g{y(t)} = reshape(a(t,:),[m,n]);
    lgd{y(t)} = sprintf('a at (%d,%d)',i(t),j(t));    
end

% find parameters
fg_title = sprintf('%s:  %s=%d, %s=%d, %s=%3.2f, %s=%3.2f',...
par.fname_base,...
'r_x', par.spatial_neighborhood_x,...
'\sigma_x',par.sigma_x,...
'\sigma_{IC}',par.sig_IC,...
'repulsion',par.offset);

openfigure(nr,nc,fg_title,0); 
dispimg(g,[nr,nc],lgd);

% fix
subplot(nr,nc,nc*3);
plot(s,'ro'); title('\lambda');
axis square; axis tight; set(gca,'XTick',[]);
for t=1:length(k),
    subplot(nr,nc,y(t));
    hold on;
    text(j(t),i(t),'+');
end
hold off
