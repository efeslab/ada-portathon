image_current = '/hid/jshi';

image_dir = 'vr05_5 ';
pg_path = '/hid/jshi/422toppm/422toppm';

cm = sprintf('cd %s',image_dir);
disp(cm);
eval(cm);

d = dir('seq*');
filename = char(sort({d.name}));

for j=1:size(filename),
 cm = sprintf('!%s %s',pg_path,deblank(filename(j,:)));
disp(cm); 
eval(cm);
end


%%% change back
cm = sprintf('cd %s',image_current);
disp(cm);eval(cm);


if 0,
  deblank(filename(f,:));
end
