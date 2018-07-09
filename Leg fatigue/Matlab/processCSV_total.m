clear all
clc
close all

% This program will call a '.csv' file, locate EMG, Force/Event,
% Accelerattion data, save the header (name and unit) and the numeric data
% into two mat files, respectively.

%Functions called here:
% --- csv2cell.m

% --- saveAllEMGMat.m
% --- saveAllForceEventMat.m
% --- saveAllAccelerationMat.m
% note: "ChannelData_select.m" was called in the above three functions


file_path=pwd;
addpath([file_path '\processCSV_Total']);

[num,txt,raw]=xlsread('LegFatigueTesting_subjects info.xlsx'); % on the workstation
%[num,txt,raw]=xlsread('LegFatigueTesting_subjects info_laptop.xlsx'); %on the laptop


%% -----------------** Open desired trials (make sure to input the correct Testing NO. ("testNo")**------------------------

% testNo=1;  % the testing No.
for testNo=16:1:17
    subjectI=testNo+2; % the corresponding row in the raw cell
    
    Trial_path=[raw{subjectI,4} '\'];
    Output_path=[raw{subjectI,5} '\'];
    
    
    %% only look at four trials
    filenames={'MVC30_Fatigue1.csv','MVC30_Fatigue2.csv','MVC60_Fatigue1.csv','MVC60_Fatigue2.csv'};
    
    for fn=1:size(filenames,2)
        filename0=filenames{1,fn};
        
        if exist([Trial_path '\' filename0],'file')==0
            warning([filename0 ' does not exist.']);
        else
            if exist([Trial_path '\' filename0],'file')>0
                filename=filename0;
                [Trial_name,~]=strtok(filename,'.');
                
                fid = fopen([Trial_path '\' filename], 'rt');
                
                Mat_cell = csv2cell(fid);
                

               saveAllForceEventMat(Mat_cell,Trial_name,Output_path);
                saveAllAccelerationMat(Mat_cell,Trial_name,Output_path);
%                  saveAllEMGMat(Mat_cell,Trial_name,Output_path);
                
            end
        end
        clear  Mat_cell
    end
    
end


