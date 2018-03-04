function [diff,corr,mag,angle] = get_diff_free(I,J)

[angle,mag,c2,c3] = compute_angle(I);
[angleJ,magJ] = compute_angle(J);

corr = cos(angle).*cos(angleJ) + sin(angle).*sin(angleJ);
threshold = 0.075*max(max(mag(5:size(mag,1)-5,5:size(mag,2)-5)));
diff = (abs(corr)<0.9).*(mag>threshold);