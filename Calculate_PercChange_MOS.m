%This function returns the %change in antero-posterior (AP) and medio-lateral (ML) MOS
% Required Input =
% Extrapolated center of mass (XCOM)
% Coordinates of BOS - Front, Back, Left and Right
% Slip frame
% Slip side

% Output =
% Percent Changes in MOS in AP and ML directions from Least Stable Position to Compensatory Step
% Time Taken from Least Stable Position to Compensatory Step

% Created by Kumar P. and Arora T. on May 29, 2017
% last updated on May 30, 2017


function [posterior_output lateral_output] = Calculate_PercChange_MOS

% fourdigit_subject_id = input('Please enter the 4 digits participant id: ');   % User will enter the input
close all % close any previously open plots
[fourdigit_subject_id] = input('Please enter the 4 digits participant id: ');

% create a function to load participant's data
[slip_trial_path, footfall_file_path] = generate_slip_trial_name(fourdigit_subject_id );

load (slip_trial_path);
load (footfall_file_path);

% load MOS data

[MOS_Data] = SCIHaptic_XCOM_MOS_Calc(com_data,kin_data,footstate_data);



% obtaining slip start frame (used only for plotting later) and Posterior_MOS at Rear Lift Off and compensatory step

slipstart_raw = input('please input the frame number when slip starts: ');
slipstart = slipstart_raw - (kin_data.start_frame - 1);
liftoff_framenumber_raw = input('please input the frame number of rear foot lift-off after slip: ');
liftoff_framenumber = liftoff_framenumber_raw - (kin_data.start_frame - 1);

post_MOS_LO = MOS_Data.back_mos (liftoff_framenumber);

compensatorystep_framenumber_raw = input('please input the frame number of compensatory step: ');
compensatorystep_framenumber = compensatorystep_framenumber_raw - (kin_data.start_frame - 1);
post_MOS_compstep = MOS_Data.back_mos (compensatorystep_framenumber);


% calculating percent change in Posterior_MOS

percentagechangeinPosterior_MOS = 100*((post_MOS_compstep - post_MOS_LO)/post_MOS_LO);

% obtaining slip side M-L MOS at Lift Off and Compensatory step

slipfoot = input('enter slip foot (right = 1/left = 2): ');

if slipfoot == 1
    lateral_MOS_LO = MOS_Data.right_mos (liftoff_framenumber);
    lateral_MOS_compstep = MOS_Data.right_mos (compensatorystep_framenumber);
    
elseif slipfoot == 2
    lateral_MOS_LO = MOS_Data.left_mos (liftoff_framenumber);
    lateral_MOS_compstep = MOS_Data.left_mos (compensatorystep_framenumber);
else
    disp ('input should be either 1(right) or 2(left)');
end

% calculating percent change in Lateral_MOS

percentagechangeinLateral_MOS = 100*((lateral_MOS_compstep - lateral_MOS_LO)/lateral_MOS_LO);

% calculating timetaken
samplingrate = kin_data.video_frame_rate;
timetaken_msec = 1000*((double(compensatorystep_framenumber) - double(liftoff_framenumber))/ samplingrate);


% Creating Plots

timeaxis_msec = linspace(1,((length(MOS_Data.back_mos)/samplingrate)*1000), length(MOS_Data.back_mos));

% creating subplots to visulaize the data
APXCOMData = MOS_Data.Xcom(:,2);
FrontBOS = MOS_Data.front_bos;
BackBOS = MOS_Data.back_bos;
FrontMOS = MOS_Data.front_mos;
BackMOS = MOS_Data.back_mos;
if fourdigit_subject_id == 2025
    APXCOMData = APXCOMData(1:186);
    FrontBOS = FrontBOS (1:186);
    BackBOS = BackBOS(1:186);
    FrontMOS = FrontMOS (1:186);
    BackMOS = BackMOS (1:186);
    timeaxis_msec = timeaxis_msec(1:186);
elseif fourdigit_subject_id == 1010;
    APXCOMData = APXCOMData (1:198);
    FrontBOS = FrontBOS (1:198);
    BackBOS = BackBOS (1:198);
    FrontMOS = FrontMOS (1:198);
    BackMOS = BackMOS (1:198);
    timeaxis_msec = timeaxis_msec (1:198);
end
figure (1)
subplot(2,1,1)
hold on

plot(timeaxis_msec, FrontBOS,'b')
plot(timeaxis_msec, APXCOMData,'--g')
plot(timeaxis_msec, BackBOS,'r')

legend ('Front BOS', 'XCOM', 'Back BOS','location','southeast' );
xlabel('Time(msec)');
ylabel('BOS (mm)');
title('A-P Base of Support, Extrapolated Center of Mass')
ax = axis;
axis([0 timeaxis_msec(end) ax(3) ax(4)]);
hold off

correction_factor = (timeaxis_msec(2)-timeaxis_msec(1)); % this will be used to match axes of mos and line plots;
line ([(slipstart-1)*correction_factor (slipstart-1)*correction_factor],[ax(3) ax(4)],'color', 'yellow'); % -1 is used to match line (which starts with 0) with other data that start with 1
line ([(liftoff_framenumber-1)*correction_factor (liftoff_framenumber-1)*correction_factor],[ax(3) ax(4)],'color', 'red');
line ([(compensatorystep_framenumber-1)*correction_factor (compensatorystep_framenumber-1)*correction_factor],[ax(3) ax(4)],'color', 'green');


subplot (2,1,2)
hold on
plot(timeaxis_msec, FrontMOS,'b')
plot(timeaxis_msec, BackMOS, 'r')

xlabel('Time(msec)');
ylabel('MOS(mm)');
title('A-P Margin of Stability')
ax = axis;
axis([0 timeaxis_msec(end) ax(3) ax(4)]);
hold off

line ([(slipstart-1)*correction_factor (slipstart-1)*correction_factor],[ax(3) ax(4)],'color', 'yellow'); % -1 is used to match line (which starts with 0) with other data that start with 1
line ([(liftoff_framenumber-1)*correction_factor (liftoff_framenumber-1)*correction_factor],[ax(3) ax(4)],'color', 'red');
line ([(compensatorystep_framenumber-1)*correction_factor (compensatorystep_framenumber-1)*correction_factor],[ax(3) ax(4)],'color', 'green');

legend ('Front MOS', 'Back MOS', 'Slip Start', 'Max-destabilization', 'Compensatory Step',  'location','southeast')


%% Plotting Latero-lateral MOS graphs

figure (2)
subplot(2,1,1)
hold on

if slipfoot==1
    bos_main = MOS_Data.right_bos;
    bos_other = MOS_Data.left_bos;
    mos_main = MOS_Data.right_mos;
    mos_other = MOS_Data.left_mos;
    color_main = 'r';
    color_other = 'b';
else
    bos_main = MOS_Data.left_bos;
    bos_other = MOS_Data.right_bos;
    mos_main = MOS_Data.left_mos;
    mos_other = MOS_Data.right_mos;
    color_main = 'b';
    color_other = 'r';
end

MLXCOMData = MOS_Data.Xcom(:,1);
if fourdigit_subject_id == 2025
    MLXCOMData = MLXCOMData(1:186);
    bos_main = bos_main(1:186);
    bos_other = bos_other(1:186);
    mos_main = mos_main (1:186);
    mos_other = mos_other (1:186);
elseif fourdigit_subject_id == 1010
    MLXCOMData = MLXCOMData(1:198);
    bos_main = bos_main(1:198);
    bos_other = bos_other(1:198);
    mos_main = mos_main(1:198);
    mos_other = mos_other(1:198);
end
plot(timeaxis_msec, bos_main, color_main)
plot(timeaxis_msec, MLXCOMData,'--g')
plot(timeaxis_msec, bos_other,color_other)

legend ('Slip Side BOS', 'XCOM', 'Non-slip Side BOS','location','southeast' );
xlabel('Time(msec)');
ylabel('L-L BOS (mm)');
title('L-L Base of Support, Extrapolated Center of Mass')
ax = axis;
axis([0 timeaxis_msec(end) ax(3) ax(4)]);
hold off

correction_factor = (timeaxis_msec(2)-timeaxis_msec(1)); % this will be used to match axes of mos and line plots;
line ([(slipstart-1)*correction_factor (slipstart-1)*correction_factor],[ax(3) ax(4)],'color', 'yellow'); % -1 is used to match line (which starts with 0) with other data that start with 1
line ([(liftoff_framenumber-1)*correction_factor (liftoff_framenumber-1)*correction_factor],[ax(3) ax(4)],'color', 'red');
line ([(compensatorystep_framenumber-1)*correction_factor (compensatorystep_framenumber-1)*correction_factor],[ax(3) ax(4)],'color', 'green');


subplot (2,1,2)
hold on

plot(timeaxis_msec, mos_main, color_main)
plot(timeaxis_msec, mos_other, color_other)

xlabel('Time(msec)');
ylabel('MOS(mm)');
title('L-L Margin of Stability')
ax = axis;
axis([0 timeaxis_msec(end) ax(3) ax(4)]);
hold off

line ([(slipstart-1)*correction_factor (slipstart-1)*correction_factor],[ax(3) ax(4)],'color', 'yellow'); % -1 is used to match line (which starts with 0) with other data that start with 1
line ([(liftoff_framenumber-1)*correction_factor (liftoff_framenumber-1)*correction_factor],[ax(3) ax(4)],'color', 'red');
line ([(compensatorystep_framenumber-1)*correction_factor (compensatorystep_framenumber-1)*correction_factor],[ax(3) ax(4)],'color', 'green');

legend ('Slip-side MOS', 'Non Slip-side MOS', 'Slip Start', 'Max-destabilization', 'Compensatory Step',  'location','southeast')

posterior_output = [post_MOS_LO post_MOS_compstep percentagechangeinPosterior_MOS timetaken_msec];
lateral_output = [lateral_MOS_LO lateral_MOS_compstep percentagechangeinLateral_MOS timetaken_msec];
return





