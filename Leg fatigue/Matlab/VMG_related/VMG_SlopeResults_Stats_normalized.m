%% Run stats on the results
clear all
close all
clc

%% MVC 30 and MVC 60 separately
% Average the results from two trials (next to each other)
currentDir=pwd;
addpath([currentDir '\functions']);


%% slope_fft restuls
load slopeTotal_MVC30_fftTable_normalized
load slopeTotal_MVC60_fftTable_normalized
load slopeTotal_fftTable_normalized

% average the values from two trials 
ave_slopeTotal_MVC30_fftTable=aveTrials(slopeTotal_MVC30_fftTable);
ave_slopeTotal_MVC60_fftTable=aveTrials(slopeTotal_MVC60_fftTable);
ave_slopeTotal_fftTable=aveTrials(slopeTotal_fftTable);

% One-sample t-test to compare the slope with 0
MeanAve=0; % the mean of the slope compares to 'MeanAve' (=0)

[~,combinedTable_slopeTotal_MVC30_fft]=addOneSampleTtest(ave_slopeTotal_MVC30_fftTable,MeanAve);
[~,combinedTable_slopeTotal_MVC60_fft]=addOneSampleTtest(ave_slopeTotal_MVC60_fftTable,MeanAve);
[~,combinedTable_slopeTotal_fft]=addOneSampleTtest(ave_slopeTotal_fftTable,MeanAve);


%% slope_rms results
load slopeTotal_MVC30_rmsTable_normalized
load slopeTotal_MVC60_rmsTable_normalized
load slopeTotal_rmsTable_normalized

% average the values from two trials 
ave_slopeTotal_MVC30_rmsTable=aveTrials(slopeTotal_MVC30_rmsTable);
ave_slopeTotal_MVC60_rmsTable=aveTrials(slopeTotal_MVC60_rmsTable);
ave_slopeTotal_rmsTable=aveTrials(slopeTotal_rmsTable);

% One-sample t-test to compare the slope with 0
[~,combinedTable_slopeTotal_MVC30_rms]=addOneSampleTtest(ave_slopeTotal_MVC30_rmsTable,MeanAve);
[~,combinedTable_slopeTotal_MVC60_rms]=addOneSampleTtest(ave_slopeTotal_MVC60_rmsTable,MeanAve);
[~,combinedTable_slopeTotal_rms]=addOneSampleTtest(ave_slopeTotal_rmsTable,MeanAve);


% paried t-test to compare the slope values between MVC 30 vs. MVC 60 (rms
% and fft results)
AlphaVal=0.05;
[Table3060_rms,combinedTable_slope_MVC30vsMVC60_rms]=add3060PairedTtest(ave_slopeTotal_MVC30_rmsTable,ave_slopeTotal_MVC60_rmsTable,AlphaVal);

[Table3060_fft,combinedTable_slope_MVC30vsMVC60_fft]=add3060PairedTtest(ave_slopeTotal_MVC30_fftTable,ave_slopeTotal_MVC60_fftTable,AlphaVal);


%% save to file
writetable(combinedTable_slopeTotal_MVC30_rms,'StatsResults_slope_normalized.xls','Sheet','rms_MVC_30_normalized','WriteRowNames',true)  ;
writetable(combinedTable_slopeTotal_MVC60_rms,'StatsResults_slope_normalized.xls','Sheet','rms_MVC_60_normalized','WriteRowNames',true)  ;
writetable(combinedTable_slopeTotal_rms,'StatsResults_slope_normalized.xls','Sheet','rms_Total_normalized','WriteRowNames',true)  ;


writetable(combinedTable_slopeTotal_MVC30_fft,'StatsResults_slope_normalized.xls','Sheet','fft_MVC_30_normalized','WriteRowNames',true)  ;
writetable(combinedTable_slopeTotal_MVC60_fft,'StatsResults_slope_normalized.xls','Sheet','fft_MVC_60_normalized','WriteRowNames',true)  ;
writetable(combinedTable_slopeTotal_fft,'StatsResults_slope_normalized.xls','Sheet','fft_Total_normalized','WriteRowNames',true)  ;

writetable(combinedTable_slope_MVC30vsMVC60_rms,'StatsResults_slope_normalized.xls','Sheet','MVC30vsMVC60_rms_normalized','WriteRowNames',true)  ;
writetable(combinedTable_slope_MVC30vsMVC60_fft,'StatsResults_slope_normalized.xls','Sheet','MVC30vsMVC60_fft_normalized','WriteRowNames',true)  ;
