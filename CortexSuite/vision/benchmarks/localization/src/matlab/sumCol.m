function ret = sumCol(mat)

row = size(mat, 1);
col = size(mat, 2);

ret = zeros(row, 1);

for i=1:row
	temp = 0;
	for j=1:col
		temp = temp + mat(i, j);
	end
	ret(i, 1) = temp;
end
