function [na,nb,nc,nd] = ks_2d(cum_filter)

[nb_filters,nb_bins] = size(cum_filter);

T = 1;

for j = [1:nb_filters],
   for l = [1:nb_bins],
	nc(j,l) = sum(cum_filter(1:j,l));
        nd(j,l) = j*T - nc(j,l);

	if (j~= nb_filters),
	  nb(j,l) = sum(cum_filter(j+1:nb_filters,l));
	  na(j,l) = (nb_filters-j)*T-nb(j,l);
        else
          nb(j,l) = 0;
          na(j,l) = 0;
        end
    end
end
