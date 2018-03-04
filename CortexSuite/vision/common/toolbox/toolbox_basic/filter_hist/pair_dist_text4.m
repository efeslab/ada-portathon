function [A] = pair_dist_text4(Iw,Cresult,cso)  
%
%  A = pair_dist_text3(Cum,cumhists);
%
%

%s1 = Cum(2);s2 = Cum(1);

figure(1);hold on;plot(cso(1),cso(2),'bo');

ws = [10,10];

lws = 3;
gap = 7;

J1 = get_win(Iw,round(cso),ws);
Jbar1 = abs(get_win5(Cresult,round(cso),ws));
hists1 = get_hist(J1,Jbar1);
cumhists1 = get_cumhist(hists1);
[na1,nb1,nc1,nd1] = ks_2d(cumhists1.text');

figure(4);colormap(gray);
imagesc(reshape(abs(Jbar1),size(Jbar1,1),size(Jbar1,2)*size(Jbar1,3)));
colorbar;axis('image');drawnow;

figure(2);
subplot(2,5,1);imagesc(J1);%colormap(gray)
subplot(2,5,2);imagesc(hists1.text');title('hist_1');colorbar;
subplot(2,5,3);imagesc(cumhists1.text');title('cumhist_1');colorbar;
subplot(2,5,4);imagesc(nc1);title('nc_1');colorbar
subplot(2,5,5);imagesc(nb1);title('nb_1');colorbar
drawnow;

k = sqrt(2)/2;M = prod(size(cumhists1.text));
N = k*sqrt(M);
r1 = 0.001;r2 = 0.001;
con = N/(1+ (sqrt(1-0.5*(r1*r1+r2*r2)))*(0.25-0.75/N));

jid = 1;
for jj=cso(2)-lws*gap:gap:cso(2)+lws*gap,
   kid = 1;
   for kk=cso(1)-lws*gap:gap:cso(1)+lws*gap,

	figure(1);hold on; plot(kk,jj,'r*');drawnow;

	J2 = get_win(Iw,round([kk,jj]),ws);
	Jbar2 = get_win5(Cresult,round([kk,jj]),ws);

	hists2 = get_hist(J2,Jbar2);
	cumhists2 = get_cumhist(hists2);
	[na2,nb2,nc2,nd2] = ks_2d(cumhists2.text');

	figure(2);	
	subplot(2,5,6);imagesc(J2);%colormap(gray)
	subplot(2,5,7);imagesc(hists2.text');title('hist_2');colorbar
	subplot(2,5,8);imagesc(cumhists2.text');title('cumhist_2');colorbar
	
	diffa = abs(na2-na1);diffb =abs(nb2-nb1);
 	diffc = abs(nc2-nc1);diffd = abs(nd2-nd1);

	maxs(1) = max(max(diffa));maxs(2) = max(max(diffb));
	maxs(3) = max(max(diffc));maxs(4) = max(max(diffd));

	maxs = maxs/6;for j=1:4, sig(j) = signif(con*maxs(j)); end

	subplot(2,5,9);imagesc(diffc);title('diff_{nc}');colorbar
	subplot(2,5,10);imagesc(diffb);title('diff_{nb} ');colorbar

	disp(sprintf('max diff is %f\n',min(sig)));

	A(jid,kid) = min(1,min(sig));

	%disp('press return to continue');
	pause(3);

	kid = kid+1;
   end
  jid = jid+1;
end

figure(1);hold off;
