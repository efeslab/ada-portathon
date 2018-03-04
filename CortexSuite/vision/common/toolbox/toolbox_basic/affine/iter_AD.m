function [A,D] = iter_AD(I,J,mask,w,k,num_trans)
%
%  function [A,D] = iter_AD(I,J,mask,w,k,num_trans)
%
%  find the affine motion A, and displacement D,
%  such that difference between I(Ax-D) and J(x) is minimized.
%  If k <= num_trans, only translation is computed.  This is useful
%  in practice, when translation is relative large.
%
%  mask: the weight matrix,
%  w: window size for estimating gradiant, use a large value
%     when A,D are large.
%

%
%  Jianbo Shi
%


if k <= num_trans,
  D = find_D(I,J,mask,w);
  A = eye(2);
else
  [A,D] = find_AD(I,J,mask,w);
end

