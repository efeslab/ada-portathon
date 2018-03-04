function compileAll(Cdir);

files = dir([Cdir,'/*.c']);

for j=1:length(files),
	
	cm = sprintf('mex %s',files(j).name);
disp(cm);
eval(cm);
end
