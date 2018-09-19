% test EMG functions: plot orginal EMG
clear all
close all
clc

%% 
load MVC60_Fatigue2_Biomonitor.mat
% load MVC100_1a.mat

%load S21_MVC60_Fatigue1_Biomonitor.mat

EMGdata=cell2mat(Data(:,2:8)); % 7 EMG Data
emg=EMGdata(:,1); %EMG1
t=cell2mat(Data(:,1)); %time 
fs=round(1/(t(2)-t(1))); % sampling frequency (1000Hz or 1500Hz)


%% filter EMG
filtemg=EMG_filter(emg,fs);
% filtemg=EMG_filter_bandonly(emg,fs);

% ----- plot to check -----
figure(1)
subplot(2,1,1)
p1=plot(t,emg,'k'); % original EMG
legend('original EMG')
xlabel('Time (sec)')
ylabel('Potential (mV)')

subplot(2,1,2)
p2=plot(t,filtemg,'c'); % filtered EMG
legend(p2,'filtered EMG')
xlabel('Time (sec)')
ylabel('Potential (mV)')

%% Rectify and RMS EMG
signal=filtemg;
windowlength=fs*0.5; % 0.1second
overlap=windowlength-1;
zeropad=1;

RecRmsEMG=EMG_RecRms(signal, windowlength, overlap, zeropad);

% plot to check
figure (1)
subplot(2,1,2)
hold on
plot(t,RecRmsEMG,'b')


%% FFT with moving windows and steps (time-frequency)
window=1; % 1 seconds
step=0.1; % incremental step = 0.1 s

totalStep=1:step*fs:length(t)-window*fs;
n=length(totalStep);

time_w=zeros(n,1);
MedianFr_w=zeros(n,1);
MeanFr_w=zeros(n,1);
PDS_w=cell(n,4); % frequency, PSD, and power etc.

i=0;
for iw=1:step*fs:length(t)-window*fs  %index in "t"
    i=i+1;
    selected_emg=filtemg(iw:iw+window*fs,1);
        
    signal=selected_emg;
    [pxx, f,MedianFr,MeanFr]=MedianFMeanF(signal, fs);

    
    time_w(i,1)=t(iw+window*fs/2,1);
    MedianFr_w(i,1)=MedianFr;
    MeanFr_w(i,1)=MeanFr;
    
    PDS_w{i,1}=f;
    PDS_w{i,2}=pxx;
    PDS_w{i,3}=areaCal(f,pxx); %power
    
    [H2Lratio,H2Mratio,M2Lratio,areaL,areaM,areaH]=HLpowerRatio(f,pxx);
    PDS_w{i,4}=[H2Lratio,H2Mratio,M2Lratio,areaL,areaM,areaH];
    
end

% selected exertion range (excluding no-exertion range, such as resting and relaxing period)
power_w=cell2mat(PDS_w(:,3)); % power in the selected window
indRange=find(power_w>0.5*median(power_w)); % larger than 25% of median power
indS=min(indRange):max(indRange);

% curve fitting to time-frequency plots
p1 = polyfit(time_w,MedianFr_w,4); 
f1 = polyval(p1,time_w);

p2 = polyfit(time_w,MeanFr_w,4); 
f2 = polyval(p2,time_w);

figure (10)
hold on
p(1)=plot(time_w,MedianFr_w,'r');
p(2)=plot(time_w,MeanFr_w,'b');

plot(time_w,f1,'r')
plot(time_w,f2,'b')

legend([p(1),p(2)],{'Median Frequency (Hz)','Mean Frequency (Hz)'})


figure (20)
% raw EMG
subplot(2,2,1)
plot(t,emg,'k'); % original EMG
legend('original EMG')
xlabel('Time (sec)')
ylabel('Potential (mV)')
% xlim([0,85])

% median frequency
subplot(2,2,2)
plot(time_w,MedianFr_w,'r');
xlabel('Time (sec)')
ylabel('Frequency (Hz)')
% xlim([0,85])

P1 = polyfit(time_w(indS),MedianFr_w(indS),3); 
F1 = polyval(P1,time_w(indS));
hold on
plot(time_w(indS),F1,'m')
legend('Median Frequency (Hz)','Fitted Curve')

% power
subplot(2,2,3)
plot(time_w,power_w,'r');
legend('Power')
xlabel('Time (sec)')
ylabel('Power')
% xlim([0,85])


% HtoL power ratio
Ratios=cell2mat(PDS_w(:,4));
subplot(2,2,4)
hold on
powerP(1)=plot(time_w,Ratios(:,1),'b');
powerP(2)=plot(time_w,Ratios(:,2),'k');
powerP(3)=plot(time_w,Ratios(:,3),'m');
%powerP(4)=plot(time_w,Ratios(:,4),'c');

legend(powerP,{'High to Low power ratio','High to Middle power ratio','Middle to Low power ratio'})
xlabel('Time (sec)')


