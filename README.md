# Data-Analysis-Scripts

Scripts to exctract data from the software Labchart and calculate margin of stability.

## `readRMT_VA`
readRMT_VA lets you import already filtered data RMT provided by the VA Medical Center site and calculate amplitude of the background and MEPs
the script will prompt you to select the .txt file provided by the site. It will plot the MEPs and ask you to select the start and end of background and MEP
it will output the amplitudes of background and MEP.

## `ExtractEMGSortingBlocks`

ExtractEMGSortingBlocks extracts pages of data from the matlab file exported from LabChart.
Once run, this function will ask to select the *.mat file. 
Using the information provided, this function will yield the pages with EMG data <br/>
Note: 
1. this function does not filter the data, so data extracted from LabChart should be pre-filtered before exporting from Labchart into MATLAB format
2. export only those channels that you want (including comment channel) to use or else you may get incorrect data

## `CombinedPages`
ExtractEMG extracts data from the matlab file exported from LabChart.
Once run, this function will ask to select the *.mat file and then the excel file with page nos corresponding to each intensity.
Using the information provided, this function will yield the arrays with EMG data contained in different pages.

## `Calculate_PercChange_MOS`

Calculate_PercChange_MOS returns the %change in antero-posterior (AP) and medio-lateral (ML) MOS.
