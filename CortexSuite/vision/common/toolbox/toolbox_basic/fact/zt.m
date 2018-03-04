% the z' operator described in the paper (returns a row vector)

function v = zt(a, b)

v = [	a(1)*b(1), a(1)*b(2)+a(2)*b(1), a(1)*b(3)+a(3)*b(1), ...
	a(2)*b(2), a(2)*b(3)+a(3)*b(2), a(3)*b(3) ];
