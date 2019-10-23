function filtVMG=VMG_filter(signal,fs)

% % Input:
% % signal: signal data
% % fs: signal sampling frequency
% 
% %%% example:
% clear all
% close all
% clc
% 
% load MVC60_Fatigue2_Biomonitor.mat
% 
% EMGdata=cell2mat(Data(:,2:8)); % 7 EMG Data
% emg=EMGdata(:,1); %EMG1
% fs=1500; % sampling frequency



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
HPFc=2;
fNorm = HPFc / (fs/2);                   %HPFc cutoff frequency, FsHz sample rate
[b,a] = butter(5, fNorm, 'high'); 
data_filt = filtfilt(b, a, signal); 

LPFc=100;
fNorm = LPFc / (fs/2);                   %HPFc cutoff frequency, FsHz sample rate
[c,d] = butter(5, fNorm, 'low'); 
data_filt = filtfilt(c, d, data_filt); 

% 
[f,g] = butter(2, [59/(fs/2) 61/(fs/2)], 'stop'); %60Hz notch filter
filtVMG= filtfilt(f, g, data_filt); 

