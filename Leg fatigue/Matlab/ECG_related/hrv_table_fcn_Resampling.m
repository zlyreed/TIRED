function [HRV_total_Resampling,tnn, nni]=hrv_table_fcn_Resampling(Data,window_seconds,Freq_resample)
%% Initializing mhrv toolbox

% input: Data (1X15 cell)-- output from biomonitor

% output: a table with all HRV results
%      tnn2 and nni2: time and nni from Biomonitor with filter applied (no resampling)
% tnn and nni: time and nni from Biomonitor with filter and resampling applied 



% %% Example: ECG related features (use RRI from Biomonitor output)
% clear all; close all; clc;
% 
% % test at mhrv-master folder
% path=pwd;
% load([pwd '\db\mitdb\S22_MVC60_Fatigue2.mat']);

% Freq_resample=50;
% window_seconds=10; % window length in seconds


%% Initializing mhrv toolbox
mhrv_init [-f/--force];

% load([TestData_path 'Noraxon_mat\' TrialName '.mat']);
time0=Data{1,1};
RRi=Data{1,14}; % R-R interval (ms) from Biomonitor
ECG=Data{1,10};  %'Noraxon Desk Receiver.BIO 1 ECG, uV'


% ### Use RRI from Biomonitor output: remove "step" in the Biomonitor-output RRi, filtered, and resampled (maybe not) 
[time_sel,RRi_sel]=rmvStep(time0, RRi/1000); % remove "step" data
[nni2, tnn2, ~] = filtrr(RRi_sel, time_sel); % filter nni


T_resample=min(tnn2):1/Freq_resample:max(tnn2);
NN_resample=interparc(length(T_resample),tnn2,nni2,'linear');
tnn=NN_resample(:,1);
nni=NN_resample(:,2);




 %% ************* Calculate HRV frequency, non-linear metrics and fragmentation indices using moving windows ********
NNIf=nni; % use the RRi from Biomonitor ouput, which was filtered and **resampled**
TIMEf=tnn;

nWindow=floor((max(TIME)-0)/window_seconds); % number of the windows

% prealloacte tables
time_Tablef=table;
hrv_Freq=table;

i=0;
for wn=0:window_seconds:window_seconds*(nWindow-1)  % windows based on time
    i=i+1;
    
    
    % time range within the selected window
    rangef_min=wn;
    rangef_max=wn+window_seconds;
    
    % nni values in the selected window
    nni_window_indexf=find(TIMEf>=rangef_min&TIMEf<=rangef_max);
    nni_windowf=NNIf(nni_window_indexf);
    tnn_windowf=TIMEf(nni_window_indexf);
    
    % get time 
%     time_Tablef{i,1}=min(tnn_windowf); % time in table format    
     time_Tablef{i,1}=wn; % time in table format  

    % Freq domain metrics
    [hrv_fd, ~, ~,  pd_freq ] = hrv_freq(nni_windowf);
    hrv_Freq(i,:)=hrv_fd;
    
%     %Calcualtes non-linear HRV metrics based on Poincaré plots, detrended fluctuation analysis (DFA) [2]_  and Multiscale Entropy (MSE) [3]_.
%     [ hrv_nl, plot_data ] = hrv_nonlinear( nni_windowf);
%     hrv_NonLinear(i,:)=hrv_nl;
    
    
%     %Computes HRV fragmentation indices [1]_ of a NN interval time series.
%     [ hrv_frag ] = hrv_fragmentation( nni_windowf );
%     hrv_Fragmentation(i,:)=hrv_frag;
    
end

 time_Tablef.Properties.VariableNames = {'Time'};
%  hrv_FreqOtherTotal=[ time_Tablef,hrv_Freq,hrv_Fragmentation]; 
HRV_total_Resampling=[ time_Tablef,hrv_Freq]; 
 

