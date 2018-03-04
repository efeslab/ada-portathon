function [id_i,id_j,ids] = show_edge(I,MI,thI);
%
% show_edge(I,MI,thI);
%
 
[id_i,id_j,tmp] = find(MI);
ids = sub2ind(size(I),id_i,id_j);
clf;im(I);colormap(gray);hold on;
quiver(id_j,id_i,-sin(thI(ids)),cos(thI(ids)),0.5);hold off;


