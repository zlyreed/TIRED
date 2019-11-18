%% Run stats on the results
clear all
close all
clc

%% MVC 30 and MVC 60 separately
% Average the results from two trials (next to each other)
currentDir=pwd;
addpath([currentDir '\functions']);


%% BeginEnd_fft restuls
load BeginEnd_MVC30_fftTable
load BeginEnd_MVC60_fftTable
load BeginEnd_fftTable

% average the values from two trials 
ave_BeginEnd_MVC30_fftTable=aveTrials(BeginEnd_MVC30_fftTable);
ave_BeginEnd_MVC60_fftTable=aveTrials(BeginEnd_MVC60_fftTable);
ave_BeginEnd_fftTable=aveTrials(BeginEnd_fftTable);

% Paired t-test to compare Begin Vs. End (fft results)
AlphaVal=0.05;

[~,combinedTable_BeginEnd_MVC30_fft]=addPairedTtest(ave_BeginEnd_MVC30_fftTable,AlphaVal);
[~,combinedTable_BeginEnd_MVC60_fft]=addPairedTtest(ave_BeginEnd_MVC60_fftTable,AlphaVal);
[~,combinedTable_BeginEnd_fft]=addPairedTtest(ave_BeginEnd_fftTable,AlphaVal);


%% BeginEnd_rms restuls
load BeginEnd_MVC30_rmsTable
load BeginEnd_MVC60_rmsTable
load BeginEnd_rmsTable

% average the values from two trials 
ave_BeginEnd_MVC30_rmsTable=aveTrials(BeginEnd_MVC30_rmsTable);
ave_BeginEnd_MVC60_rmsTable=aveTrials(BeginEnd_MVC60_rmsTable);
ave_BeginEnd_rmsTable=aveTrials(BeginEnd_rmsTable);

% Paired t-test to compare Begin Vs. End (rms results)
[~,combinedTable_BeginEnd_MVC30_rms]=addPairedTtest(ave_BeginEnd_MVC30_rmsTable,AlphaVal);
[~,combinedTable_BeginEnd_MVC60_rms]=addPairedTtest(ave_BeginEnd_MVC60_rmsTable,AlphaVal);
[~,combinedTable_BeginEnd_rms]=addPairedTtest(ave_BeginEnd_rmsTable,AlphaVal);


%% save to file
writetable(combinedTable_BeginEnd_MVC30_rms,'StatsResults_BeginEnd.xls','Sheet','rms_MVC_30','WriteRowNames',true)  ;
writetable(combinedTable_BeginEnd_MVC60_rms,'StatsResults_BeginEnd.xls','Sheet','rms_MVC_60','WriteRowNames',true)  ;
writetable(combinedTable_BeginEnd_rms,'StatsResults_BeginEnd.xls','Sheet','rms_Total','WriteRowNames',true)  ;


writetable(combinedTable_BeginEnd_MVC30_fft,'StatsResults_BeginEnd.xls','Sheet','fft_MVC_30','WriteRowNames',true)  ;
writetable(combinedTable_BeginEnd_MVC60_fft,'StatsResults_BeginEnd.xls','Sheet','fft_MVC_60','WriteRowNames',true)  ;
writetable(combinedTable_BeginEnd_fft,'StatsResults_BeginEnd.xls','Sheet','fft_Total','WriteRowNames',true)  ;


