% test EMG functions 
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

% selected EMG 
fs=round(1/(t(2)-t(1))); % sampling frequency 1500Hz



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

%% FFT and MPF (the whole signal)
signal=filtemg;

[freqRes,emg_FFT,pxx, f,MedianFr,MeanFr]=EMG_fftMFP(signal, fs);

% plot to check
figure(2)
plot(freqRes,emg_FFT,'Color', [0.5 0 0.5]);

xlabel('Frequency (Hz)')

ylabel('Potential (mV)')

title('Frequency Spectrum')

hold on


figure(3)

plot(f, 10 * log10(pxx),'Color', [0.5 0 0.5])

l201=line([MedianFr MedianFr],[-160 100],'LineWidth',2.5,'Color',[1 0.5 0]);

L202=line([MeanFr MeanFr],[-160 100],'LineWidth',2.5,'Color','k');

legend([l201,L202],{strcat('Median Power Frequency (', num2str(MedianFr),' Hz)'),strcat('Mean Power Frequency (', num2str(MeanFr),' Hz)')})

xlabel('Frequency (Hz)')

ylabel('Power(mV^2/Hz)')

title('Power Spectrum (the whole data)')

%% FFT with moving windows and steps (time-frequency)
window=2; % 1 seconds
step=0.1; % incremental step = 0.1 s

i=0;
for iw=1:step*fs:length(t)-window*fs  %index in "t"
    i=i+1;
    selected_emg=filtemg(iw:iw+window*fs,1);
        
    signal=selected_emg;
    [freqRes,emg_FFT,pxx, f,MedianFr,MeanFr]=EMG_fftMFP(signal, fs);
    
    time_w(i,1)=t(iw+window*fs/2,1);
    MedianFr_w(i,1)=MedianFr;
    MeanFr_w(i,1)=MeanFr;
end

% fit a curve
p = polyfit(time_w,MedianFr_w,4); 
f = polyval(p,time_w);

p2 = polyfit(time_w,MeanFr_w,4); 
f2 = polyval(p2,time_w);

figure (10)
hold on
p(1)=plot(time_w,MedianFr_w,'r');
p(2)=plot(time_w,MeanFr_w,'b');

plot(time_w,f,'r')
plot(time_w,f2,'b')

legend([p(1),p(2)],{'Median Frequency (Hz)','Mean Frequency (Hz)'})
    
