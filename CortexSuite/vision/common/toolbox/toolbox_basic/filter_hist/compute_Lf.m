function dists = compute_Lf(F,cts,wz,nr,nc)

gap = 2*wz(1)+1;
hw = wz(1);

nr = nr+1;
nc = nc+1;

dists = zeros(size(cts,1),nr*nc);
for ctj = 1:size(cts,1),
    t1 = cutout(F,cts(ctj,:),wz);

    rid = 1;
    fprintf('>');
    
    for ri = hw+1:gap:size(F,1)-hw,
        %fprintf('[%d]',ri);
        cid = 1;
        for ci = hw+1:gap:size(F,2)-hw,
          %fprintf('(%d)',ci);
          t2 = cutout(F,[ci,ri],wz);

          dist = abs(mean(t1(:))-mean(t2(:)));

          dists(ctj,rid+cid*nr) = max(dist,dists(ctj,rid+cid*nr));

          cid = cid+1;
        end
        rid = rid+1;
     end

   %fprintf('\n');

end

