t = rj(1:50,19:50); tt = interp4(t,1);
sgn = mksgn2(182,2,[91,9]);
H = mkf_test(sgn,size(tt),1,0.01,2,300);
o = BfilterS(tt,H,size(sgn));figure(1);imagesc(o.*(o>0));axis('equal');
