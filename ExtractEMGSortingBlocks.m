function [updated_com,Pages_Channels] = ExtractEMGSortingBlocks(SampRate,TimeBeforePulse,TimeAfterPulse);

% ExtractEMGSortingBlocks extracts pages of data from the matlab file exported from LabChart
% Once run, this function will ask to select the *.mat file. 
% Using the information provided, this function will yield the pages with EMG data
% Note: 
% (1) this function does not filter the data, so data extracted from LabChart should be pre-filtered before exporting from Labchart into MATLAB format
% (2) export only those channels that you want (including comment channel) to use or else you may get incorrect data
% Created by T. Arora on Nov30, 2018

% open exported data file
[filename, path] = uigetfile ('*.mat', 'Please select the *.mat file from which you want to extract EMG data');
load(strcat(path,filename))

% asking for channels contained in the exported labchart file
ChannelsUsed = input('enter the names of channels used in square brackets with comments channel as last, e.g. if 5 is comment channel [1 2 5]: ');
Channel_index = 1:size(ChannelsUsed, 2);

% creating cells of blocks
BlockData = cell(1,size(dataend,2));
for block_no = 1:size(dataend,2)
    BlockData{block_no} = data(datastart(1,block_no): dataend(1,block_no)); %note first channel is used for identifying blocks; that is why row number is 1
end

% Note: assuming all comments were only in one of the channels, therefore finding mode indices from all com rows
com_mode_index = cell(1,size(dataend,2));
for block_no = 1:size(dataend,2)
    com_mode_index {block_no} = find(com(:,2) == block_no);
end


updated_com = zeros(size(com,1), size(Channel_index,2));

for channel_no = 1:size(ChannelsUsed,2)
    
    for com_modeno = 1:size(dataend,2)
        com_new = com(com_mode_index{1, com_modeno}, 3) + (datastart(channel_no,com_modeno) - 1); % note we are using start time for channel 1 to calculated changes
        updated_com(com_mode_index{1, com_modeno}, channel_no) = com_new;
    end
end

% extracting multiple pages
Pages_Channels = cell(1,(size(ChannelsUsed,2)-1))
start_time = updated_com - (TimeBeforePulse/1000*SampRate)+1;
end_time = updated_com + (TimeAfterPulse/1000*SampRate);

for channel_no = 1:(size(ChannelsUsed,2)-1)
    
New_pages = [];
for commentsize = 1:size(com,1)
    New_pages = [New_pages (data(start_time(commentsize,channel_no):end_time(commentsize,channel_no)))'];
end
Pages_Channels{channel_no} = New_pages
end

