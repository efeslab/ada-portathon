function v = eig_proj(u,data)

% fd = feature dimension, nv = num. of eigvectors
[fd,nv] = size(u);

[fd2,nd] = size(data);

if (fd ~= fd2),
    error(sprintf('size don't match'));
else
	v = data'*u;
end
