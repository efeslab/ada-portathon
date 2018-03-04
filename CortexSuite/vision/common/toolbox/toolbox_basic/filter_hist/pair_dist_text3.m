function [A,D] = pair_dist_text3(Cum,cumhists)  
%
%  A = pair_dist_text3(Cum,cumhists);
%
%

s1 = Cum(2);
s2 = Cum(1);

st = Cum(3) + Cum(4) + 1;
ed = size(cumhists,1);

cumhists = cumhists(st:ed,:);

np = size(cumhists,2);

sigma.text = 0.20;
sigma.mag = 0.20;
sigma.inten = 0.15;

lws = 4;


k = sqrt(2)/2;
M = 8*6;
N = k*sqrt(M);

r1 = 0.001;
r2 = 0.001;

c = N/(1+ (sqrt(1-0.5*(r1*r1+r2*r2)))*(0.25-0.75/N));

D = zeros(1,s1*s2);

nn = 1;
for j =1:s1,
   for k=1:s2,

	    id = j*s2+k;

	    cum_filter1 = reshape(cumhists(:,id),8,6)';
            [na1,nb1,nc1,nd1] = ks_2d(cum_filter1);

				
            fprintf('.');
            for jj=j-lws:j+lws,
		for kk=k-lws:k+lws,

			if ( (jj>0) & (kk>0) & (jj <= s1) & (kk <= s2)),

				idn = jj*s2+k;

				cum_filter2 = reshape(cumhists(:,idn),8,6)';
          			[na2,nb2,nc2,nd2] = ks_2d(cum_filter2);

				
				diffa = abs(na2-na1);diffb =abs(nb2-nb1);
				diffc = abs(nc2-nc1);diffd = abs(nd2-nd1);
				maxs(1) = max(max(diffa));maxs(2) = max(max(diffb));
				maxs(3) = max(max(diffc));maxs(4) = max(max(diffd));


				maxs = maxs/6;

				d = min(1,signif(c*max(maxs)));

				ids(nn) = id;
				idns(nn) = idn;
				B(nn) = d;

				D(id) = D(id) + d;
				D(idn) = D(idn) + d;

				nn = nn+1;
							
			end
			
		end
	     end
	     
      end
end

A = sparse(ids,idns,b);
