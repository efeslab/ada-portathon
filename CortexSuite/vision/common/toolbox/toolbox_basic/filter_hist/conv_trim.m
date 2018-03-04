% trims an array to remove meaningless pixels after a convolution with
% an r * c window

function[B] = conv_trim(A, r, c)

B = A(r+1:size(A,1)-r, c+1:size(A,2)-c);
