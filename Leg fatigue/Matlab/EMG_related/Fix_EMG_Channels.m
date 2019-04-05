% For the early trials, there are total 7 channels without Channel  6&7
% recording (Ch6&7=0)
%  Originally Channel 6 was for Rectus Femoris except for MVC30_Fatigue1 trial(saved in "\\cdc.gov\private\L505\lwf5\Research_NIOSH\MuscleFatigue_Testing\LegFatigueTesting05_2017-09-15_S08\Vicon_Matlab\old"); (unit: V)

% This code is to move Channel 6 to Channel 1(Rectus Femoris), and then replace Channel 6 with zeros

%%
clear all
clc
close all
% %% Fatiguing trials (NOTE: DO NOT RUN the code multiple times after fixing the columns!!)
% TrialName_Fatigue={'MVC30_Fatigue2_EMG_data.mat', 'MVC60_Fatigue1_EMG_data.mat', 'MVC60_Fatigue2_EMG_data.mat'};
% 
% %for tk=1:length(TrialName_Fatigue)
% for tk=1:1
%     load(TrialName_Fatigue{1,tk});
%     fixedArray=fixArrayColumn(EMG_data,7,2,0);
%     EMG_data=fixedArray;
%     save(TrialName_Fatigue{1,tk},'EMG_data');
%     clear EMG_data fixedArray
% end


%% Reference trials (cells)
 TrialName_Ref={'MVC100_2_EMG.mat', 'MVC100_3_EMG.mat', 'MVC100_4_EMG.mat','MVC100_5_EMG.mat'};
for tr=2:length(TrialName_Ref)
    load(TrialName_Ref{1,tr});
    endInd=size(cell_EMG,1);
    fixedCell=fixCellColumn(cell_EMG,(3:endInd),7,2,0);
    cell_EMG=fixedCell;
    save(TrialName_Ref{1,tr},'cell_EMG');
    clear cell_EMG fixedCell
end

