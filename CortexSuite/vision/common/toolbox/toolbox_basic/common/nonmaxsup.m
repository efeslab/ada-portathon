% function f = nonmaxsup(g,ismax,r) return extrema boolean map.
% Input: g = image, gradient image pair [x,y], or [x,y,g] in 3D matrix
%        ismax (=1)/0 is for non maximum/minimum suppression
%        r (=1) is the neighbourhood radius.
% Output:
%        f = thinned extrema boolean map, where
%            d (||gradient||) / d gradient = 0 

% Stella X. Yu, 2000.

function f = nonmaxsup(g,ismax,r)

if nargin<2,
    ismax = 1;
end

if nargin<3,
    r = 1;
end

i = size(g,3);
if i==3,
    x = g(:,:,1);
    y = g(:,:,2);
    g = g(:,:,3);
elseif i==2,
    x = g(:,:,1);
    y = g(:,:,2);
    g = x.*x + y.*y;
else
    [x,y] = gradient(g);
end

% label angles into 4 directions
a = angle(x - sqrt(-1).*y); % [-pi,pi)
s = ceil((abs(a)+pi/8)./(pi/4)); 
s(find(s==5)) = 1;
s(find(isnan(s))) = 1;

% augment the image
[m,n] = size(g);
newm = m + r + r;
i = [g(:,1);g(:,end);g(1,:)';g(end,:)']; % image boundary
if ismax,
    v = min(i) - 1;
else
    v = max(i) + 1;
end
i = zeros(newm,r) + v;
j = zeros(r,n) + v;
newg = [i, [j; g; j;], i];

% k = index as the interior of the new image
i = [r+1:newm-r]'+ r*newm;
j = [0:n-1].*newm;
k = i(:,ones(1,n)) + j(ones(1,m),:);
k = k(:);

% unit displacement vectors along gradient directions
d = [newm,newm-1,-1,-1-newm]'; % for 4 directions
d = d(s(:));

% non maximum suppression
f = ones(m*n,1);
g = g(:);
newd = 0;

if ismax,
    for i=1:r,
        newd = newd + d;
        f = f & (g>newg(k+newd)) & (g>newg(k-newd));
    end
else
    for i=1:r,
        newd = newd + d;
        f = f & (g<newg(k+newd)) & (g<newg(k-newd));
    end
end

f = reshape(f,[m,n]);

