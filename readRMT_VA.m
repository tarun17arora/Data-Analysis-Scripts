function [amp_avgMEP,amp_avgBackground] = readRMT_VA
% readRMT_VA lets you import already filtered data RMT provided by the VA Medical Center site and calculate amplitude of the background and MEPs
% the script will prompt you to select the .txt file provided by the site. It will plot the MEPs and ask you to select the start and end of background and MEP
% it will output the amplitudes of background and MEP

%import data in numeric form

[filename,pathname]=uigetfile({'*.txt'},'Choose the brainsight text file with emg data');
uiimport(strcat(pathname,filename))
filename (end-3:end) = [];
emptyspaces = [find(filename==' ') find(filename=='_')];
filename ([emptyspaces]) = [];
filetoload = cellstr(filename);
pause (20)
disp('you have 20 seconds to import the file. If you take longer the function will crash')

ImportedData = (eval(filetoload{1}))';

plot(ImportedData)
disp('select four points in row using left click - (1)background start, (2) background end, (3) MEP start and (4) MEP end'
[x, y] = ginput(4); % lets the user select start and end of background and MEP

x = round (x);

amp_Background = range(ImportedData((x(1)):(x(2)),:))/1000;
amp_MEP = range(ImportedData((x(3)):(x(4)),:))/1000;

avg_A = mean(ImportedData(3:end,:),2);
amp_avgMEP = range(avg_A(x(3):x(4),:))/1000;
amp_avgBackground = range(avg_A(x(1):x(2),:))/1000;
end

