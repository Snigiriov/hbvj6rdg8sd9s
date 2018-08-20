%%  choose directories
dirfrom = uigetdir('Âûáåğè ïàïêó ñ ıìîöèÿìè');
dirto = uigetdir('Âûáåğè ïàïêó, êóäà ïåğåíîñèòü ıìîöèè');
files = dir(dirfrom);
files(1:2) = [];
%%  configuration
structNames = {'Admire', 'Enthusiasm', 'Flirt',...
      'Joy', 'Negative', 'Neutral', 'Unknown'};
repeat_number = length(structNames) + 1;
check_correct = init_incorrect(repeat_number);
%%  check on existence directories
for i = 1:length(structNames)
	extPath = fullfile(dirto, '\', structNames{i});
	if ~exist(extPath, 'dir')
    	mkdir(extPath)
	end
end
%%	create text array
namesArray = [];  
for i = 1:length(structNames)
	className = sprintf('%g - %s, ',i, structNames{i});
    namesArray = [namesArray, className];
end
arrayToDisp = sprintf('0 - Quit, %s%g - Repeat', namesArray, repeat_number);
%%  main routine
for i = 1:length(files)
%   get full path to file    
    filename = fullfile(files(i).folder, '\',files(i).name);
%   extract values and play file
    [y,fs] = audioread(filename);
    sound(y, fs)
%   display text      
    fprintf('îñòàëîñü %g;  %s\n',length(files)-i+1, arrayToDisp)
%   check correct x      
    x = check_correct();   
        while x == repeat_number
            sound(y, fs);
            x = check_correct();
        end
%   quit or move file    
	if x == 0
    	break
    else
        movefile(filename, fullfile(extPath, '\'))
    end    
end
%%   function to check correct x
function check_correct = init_incorrect(repeat_number)
    check_correct = @() nf_incorrect();
%   nested function
    function x = nf_incorrect()
        x = input('ñîîòíåñòè ê ıìîöèè: ');
        while x > repeat_number || x < 0
            x = input('íåêîğğåêòíîå ÷èñëî, ââåäè  êîğğåêòíîå: ');
        end
    end
end