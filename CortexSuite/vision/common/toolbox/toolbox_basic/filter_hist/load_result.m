
fnameI = '130056';

cm = sprintf('load filter_%s.pgm.mat',fnameI);
disp(cm);
eval(cm);

text_des= reshape(text_des,size(text_des,1),size(text_des,2),size(text_des,3)*size(text_des,4));

for j=1:size(text_des,3),
   text_des(:,:,j) = abs(text_des(:,:,j)).*(text_des(:,:,j) <0);
end

%text_des = abs(text_des);


  %%%% cutoff margins,
margin = 6+10;

Iw = cutoff(I,margin);


T1 = cutoff(text_des,margin);

%%%%% reduce resolution



T1 = reduce_all(T1);
T1 = reduce_all(T1);

im5(T1,5,6);

cm = sprintf('writepnm5(''%s_f.pnm'',%s)',fnameI,'T1/70');

%  disp(cm);eval(cm);

nr = size(T1,1);
nc = size(T1,2);
