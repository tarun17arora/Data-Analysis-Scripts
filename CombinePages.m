function [CombinedPages, IntensityAndPages, data, usedData] = CombinePages (SampRate, TimeBeforePulse,TimeAfterPulse);
% ExtractEMG extracts data from the matlab file exported from LabChart
% Once run, this function will ask to select the *.mat file and then the excel file with page nos corresponding to each intensity.
% Using the information provided, this function will yield the arrays with EMG data contained in different pages

% Created by T. Arora on October 10, 2018

% Modified from CombinePages_ver1 on Feb 13, 2020 by T. Arora
% modification include outputting "usedData" variable, which gives the
% individual MEPS that are used for calculating the "CombinedPages"
% variable

[updated_com,Pages_Channels] = ExtractEMGSortingBlocks(SampRate,TimeBeforePulse,TimeAfterPulse);

data = Pages_Channels{1,1};

%% extracting page - intensity information from the excel sheet
[excelfilename, excelpath] = uigetfile ('*.xls;*.xlsx', 'Please select the excel file from which you want to extract the page and intensity information');
PageIntensityinfo = xlsread(strcat(excelpath,excelfilename));

Intensity = PageIntensityinfo(:,1);
PageNos = PageIntensityinfo (:,2:end);

IntensityAndPages = [Intensity PageNos]

CombinedPages = [];
for n_intens = 1:size(Intensity, 1)
    PageNum = PageNos(n_intens,:);
    usedData = data(:,PageNum);
    CombinedPages = [CombinedPages		mean(usedData,2)];
end
end



