function filtemg=EMG_filter_bandonly(emg,fs)

% % Input:
% % emg: EMG data
% % t: time (second) % only need for plotting
% % fs: EMG sampling frequency
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
% t=cell2mat(Data(:,1)); %time 
% fs=1500; % sampling frequency



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%% %%%%%%% STEP 2  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%% Filter EMG Data%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%% pass a band pass filter by%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%% Low pass filter: fc of 500 Hz %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%high pass filter: fc of 5hz %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% %% Added---Apply 4th order, 0-lag, Butterworth band-pass filter to raw EMG signal.
%  order = 4;
%  cutoff = [5 450];
%  [b, a] = butter(order/2, cutoff/(0.5*fs));
%  filtemg = filter(b, a, emg, [], 1);


%High Pass filter
fcH= 20;
WnH= (fcH)/(fs/2); 
[bH,aH]=butter(4,WnH,'high');

emgHigh=filtfilt(bH,aH,emg);

% %% Filter out 60 Hz noise from power
% fc60_1=59.5;
% 
% fc60_2=60.5;
% 
% Wn1= (fc60_1)/(fs/2);
% 
% Wn2=(fc60_2)/(fs/2);
% 
% [b60,a60]=butter(4,[Wn1 Wn2],'stop');
% 
% emgband=filtfilt(b60,a60,emgHigh);
% 
% 

%% Low pass filter
fcL= 450;
Wn= (fcL)/(fs/2);
[b,a]=butter(4,Wn,'low');
filtemg=filtfilt(b,a,emgHigh);


%  
 
% %% ----- plot to check -----
% figure(1)
% subplot(2,1,1)
% p1=plot(t,emg,'c'); % original EMG
% legend('original EMG')
% xlabel('Time (sec)')
% ylabel('Potential (mV)')
% 
% 
% subplot(2,1,2)
% p2=plot(t,filtemg,'b'); % filtered EMG
% legend('filtered EMG')
% 
% xlabel('Time (sec)')
% ylabel('Potential (mV)')


